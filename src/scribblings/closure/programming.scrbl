#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "programming-7"]{Programming}

@local-table-of-contents[]

@section{ast.ss}
@racketblock[
(require eopl/eopl)

(provide
  ast
  ast?
  number
  boolean
  id-ref
  function
  app
  assume
  make-bind
  bind-id
  bind-ast)

(define-datatype ast ast?
  [number (datum number?)]
  [boolean (datum boolean?)]
  [function
   (formals (list-of id?))
   (body ast?)]
  [app (rator ast?) (rands (list-of ast?))]
  [id-ref (sym id?)]
  [assume (binds  (list-of bind?)) (body ast?)])

(define-datatype bind bind?
  [make-bind (b-id id?) (b-ast ast?)])

;;; bind-id : bind? -> id?
(define bind-id
  (lambda (b)
    (cases bind b
      [make-bind (b-id b-ast) b-id])))

;;; bind-ast : bind? -> ast?
(define bind-ast
  (lambda (b)
    (cases bind b
      [make-bind (b-id b-ast) b-ast])))

(define id? symbol?)
]

@section{env.ss}
@racketblock[
(require eopl/eopl)

(provide
  env?
  empty-env
  extended-env
  lookup-env)

(define env? procedure?)

;;; lookup-env: [env?  symbol?] -> any/c
;;; lookup-env: throws "unbound identifier" error
(define lookup-env
  (lambda (e x)
    (e x)))

;;; empty-env : () -> env?
(define empty-env
  (lambda ()
    (lambda (x)
      (error 'empty-env "unbound identifier ~a" x))))

;;; extended-env :
;;;    [(list-of symbol?) (list-of any/c) env?] -> env?
(define extended-env
  (lambda (syms vals outer-env)
    (lambda (x)
      (let ([j (list-index syms x)])
        (cond
          [(= j -1) (lookup-env outer-env x)]
          [#t (list-ref vals j)])))))

;;; Returns the loction of the element in a list, -1 if the
;;; element is absent.

;;; list-index : [(listof any/c)  any/c] -> 
(define list-index
  (lambda (ls a)
    (letrec ([loop
               (lambda (ls ans)
                 (cond
                   [(null? ls) -1]
                   [(eq? (first ls) a) ans]
                   [#t (loop (rest ls) (+ 1 ans))]))])
      (loop ls 0))))

]

@section{semantic-domains.ss}
@racketblock[
(provide
  proc
  prim-proc
  closure
  
  proc?
  prim-proc?
  closure?
  
  expressible-value?
  denotable-value?
  )

;;; expressible-value? is the set of things that are the
;;; results of evaluation of expressions (asts).


(require eopl/eopl)
(require "ast.ss")
(require "env-proc.ss")

(define-datatype proc proc?
  [prim-proc
    ;; prim refers to a scheme procedure
    (prim procedure?)
    ;; sig is the signature
    (sig (list-of procedure?))] 
  [closure
    (formals (list-of symbol?))
    (body ast?)
    (env env?)])

;;; prim? : proc? -> boolean?

(define prim-proc?
  (lambda (p)
    (cases proc p
      [prim-proc (prim sig) #t]
      [else #f])))

(define closure? 
  (lambda (p)
    (cases proc p
      [prim-proc (prim sig) #f]
      [else #t])))

;;; expressible-value? : any/c -> boolean?
(define expressible-value?
  (or/c number? boolean? proc?))

;;; denotable-value? :any/c -> boolean?
(define denotable-value?
  (or/c number? boolean? proc?))

]

@section{eval-ast.ss}
@racketblock[
(require eopl/eopl)
(require "ast.ss")
(require "env-proc.ss")
(require "semantic-domains.ss")


(provide
   eval-ast)

;;; eval-ast : [ast? env?]-> expressible-value?
;;; eval-ast :  throws error

(define eval-ast
  (lambda (a env)
    (cases ast a
      [number (datum) datum]
      [boolean (datum) datum]
      [id-ref (sym) (lookup-env env sym)]
      [function (formals body)
        (closure formals body env)]
      [app (rator rands)
        (let ([p (eval-ast rator env)]
              [args (map
                      (lambda (rand)
                        (eval-ast rand env))
                      rands)])
          (if (proc? p)
            (apply-proc p args)
            (error 'eval-ast "application rator is not a proc ~a" a)))]
      [assume (binds body)
        (let* ([ids  (map bind-id binds)]
               [asts (map bind-ast binds)]
               [vals (map (lambda (a)
                            (eval-ast a env))
                          asts)]
               [new-env
                (extended-env ids vals env)])
          (eval-ast body new-env))])))


(define apply-proc
  (lambda (p args)
    (cases proc p
      [prim-proc (prim sig)
        (apply-prim-proc prim sig args)]
      [closure (formals body env)
        (apply-closure formals body env args)])))
        

(define apply-prim-proc
  (lambda (prim sig args)
    (let* ([args-sig (rest sig)])
      (cond
       [(and
          (= (length args-sig) (length args))
          (andmap match-arg-type args-sig args))
        (apply prim  args)]
       [#t (error 'apply-prim-proc
             "incorrect number or type of arguments to ~a"
             prim)]))))

;;; match-arg-type : [procedure? any/c] -> boolean?
(define match-arg-type
  (lambda (arg-type val)
    (arg-type val)))


(define apply-closure
  (lambda (formals body env args)
    (let ([new-env (extended-env formals args env)])
      (eval-ast body new-env))))

]

@section{parser.ss}
@racketblock[

(require "ast.ss")

(provide
  parse)

(define id?
  (lambda (x)
    (and
     (symbol? x)
     (not (memq x *keywords*)))))
              
(define parse
  (lambda (d)
    (match d
     [(? number? n) (number n)]
     [(? boolean? b) (boolean b)]
     [(? id? x) (id-ref x)]
    
     [(list
       'function
       (list (? id? x) ...)
       body)
      (function x (parse body))]
     
     [(list 'assume
        (list (list (? id? x) e) ...) body)
      (let* ([a (map parse e)]
             [b (map make-bind x a)])
        (assume b (parse body)))]

     [(list rator rands ...)
      (let* ([rator (parse rator)]
             [rands (map parse rands)])
        (app rator rands))]
     
     [else (error 'parse "don't know how to parse ~a" d)])))
 ]    

@section{run.ss}
@racketblock[
(require "ast.ss")
(require "env-proc.ss")
(require "semantic-domains.ss")
(require "eval-ast.ss")

(provide
 run
 *init-env*)


;;; Primitive Procedures
;;; ====================

(define nonzero? (and/c number? (not/c zero?)))


(define +p
  (prim-proc +
    (list number? number? number?)))

(define -p
  (prim-proc -
    (list number? number? number?)))

(define *p
  (prim-proc *
    (list number? number? number?)))

(define /p
  (prim-proc /
    (list number? number? nonzero?)))

(define <p
  (prim-proc  <
    (list boolean? number? number?)))

(define <=p
  (prim-proc   <=
    (list boolean? number? number?)))

(define eq?p
  (prim-proc eq?
    (list boolean? expressible-value? expressible-value?)))

(define 0?p
  (prim-proc zero?
    (list boolean? number?)))

(define *init-env*
  (extended-env
   '(+ - * / < <= eq? 0?)
   (list +p -p *p /p <p <=p eq?p 0?p)
   (empty-env)))

;;; run: ast? -> expressible-value?

(define run
  (lambda (ast)
    (eval-ast ast *init-env*)))
]
