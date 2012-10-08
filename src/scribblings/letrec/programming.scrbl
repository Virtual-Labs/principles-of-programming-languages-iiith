#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "programming-8"]{Programming}

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
  bind-ast
  make-fbind
  fbind-id
  fbind-formals
  fbind-body
  ifte
  recursive)

(define-datatype ast ast?
  [number (datum number?)]
  [boolean (datum boolean?)]
  [ifte (test ast?) (then ast?) (else-ast ast?)]
  [function
   (formals (list-of id?))
   (body ast?)]
  [recursive (fbinds (list-of fbind?)) (body ast?)]
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


(define-datatype fbind fbind?
  [make-fbind (fb-id id?)
              (fb-formals (list-of id?))
              (fb-body ast?)])

;;; fbind-id : fbind? -> id?
(define fbind-id
  (lambda (b)
    (cases fbind b
      [make-fbind (fb-id fb-formals fb-body) fb-id])))

;;; fbind-formals : fbind? -> (list-of id?)
(define fbind-formals
  (lambda (b)
    (cases fbind b
      [make-fbind (fb-id fb-formals fb-body) fb-formals])))

;;; fbind-body : fbind? -> ast?
(define fbind-body
  (lambda (b)
    (cases fbind b
      [make-fbind (fb-id fb-formals fb-body) fb-body])))


(define id? symbol?)
]

@section{env-rec.ss}
@racketblock[
(provide
  env
  env?
  empty-env
  extended-env
  extended-rec-env
  lookup-env

  proc
  prim-proc
  closure
  
  proc?
  prim-proc?
  closure?
  )

(require eopl/eopl)
(require "ast.ss")

;;; A recursive env is a union type of either
;;; * an empty environment OR

;;; * an extended environment consisting of a list of
;;;   symbols, a list of denotable values and an outer
;;;   environment.

;;; 

(define-datatype env env?
  [empty-env]
  [extended-env
    (syms (list-of symbol?))
    (vals (list-of any/c))
    (outer-env env?)]
  [extended-rec-env
    (fsyms (list-of symbol?))
    (lformals (list-of (list-of symbol?)))
    (bodies (list-of ast?))
    (outer-env env?)])

;;; Subtype Predicates
;;; ==================

;;; empty-env? : env? -> boolean?
(define empty-env?
  (lambda (e)
    (cases env e
      [empty-env () #t]
      [else #f])))

;;; extended-env? : env? -> boolean?
(define extended-env?
  (lambda (e)
    (cases env e
      [extended-env (syms vals outer-env) #t]
      [else #f])))

;;; extended-rec-env? : env? -> boolean?
(define extended-rec-env?
  (lambda (e)
    (cases env e
      [extended-rec-env (fsyms lformals bodies outer-env) #t]
      [else #f])))


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

;;; lookup-env: [env?  symbol?] -> any/c
;;; lookup-env: throws "unbound identifier" error
(define lookup-env
  (lambda (e x)
    (cases env e
      [empty-env ()
        (error
          'lookup-env
          "unbound identifier ~a" x)]
      [extended-env (syms vals outer-env)
        (let ([j (list-index syms x)])
          (cond
            [(= j -1) (lookup-env outer-env x)]
            [#t (list-ref vals j)]))]
      [extended-rec-env
       (fsyms lformals bodies outer-env)
        (let ([j (list-index fsyms x)])
          (cond
            [(= j -1)
             (lookup-env outer-env x)]
            [#t
             (let ([formals
                    (list-ref lformals j)]
                   [body (list-ref bodies j)])
                  (closure formals body e))]))])))

;;; We are building a closure during lookup.  For this
;;; reason, the proc adt definition moves into this module.


;;; Procedure ADT
;;; ==============

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


;;; Subtype Predicates
;;; ==================

;;; prim? : proc? -> boolean?

(define prim-proc?
  (lambda (p)
    (cases proc p
      [prim-proc (prim sig) #t]
      [else #f])))

(define closure? 
  (lambda (p)
    (cases proc p
      [closure (formals body env) #t]
      [else #f])))

]

@section{semantic-domains.ss}
@racketblock[
(provide
  expressible-value?
  denotable-value?
  )

;;; expressible-value? is the set of things that are the
;;; results of evaluation of expressions (asts).


(require eopl/eopl)
(require "env-rec.ss")

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
(require "env-rec.ss")
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
      [ifte (test then else-ast)
        (let ([b (eval-ast test env)])
          (if (boolean? b)
            (eval-ast (if b then else-ast) env)
            (error 'eval-ast "ifte test is not a boolean ~a" a)))]
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
          (eval-ast body new-env))]

      [recursive (fbinds body)
        (let*
          ([fids (map fbind-id fbinds)]
           [lformals (map fbind-formals fbinds)]
           [bodies (map fbind-body fbinds)]
           [new-env
             (extended-rec-env
               fids lformals bodies env)])
          (eval-ast body new-env))])))




;;; apply-proc :
;;;  [proc? (list-of expressible-value?)]
;;;    -> expressible-value?

(define apply-proc
  (lambda (p args)
    (cases proc p
      [prim-proc (prim sig)
        (apply-prim-proc prim sig args)]
      [closure (formals body env)
        (apply-closure formals body env args)])))


;;; apply-prim-proc :
;;;  [procedure? (listof procedure?)
;;;     (listof expressible-value?)] -> expressible-value?
;;;
;;; apply-prim-proc : throws error when number or type of
;;;     args do not match the signature of prim-proc

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

;;; apply-closure : [closure? (listof expressible-value?)]
;;;                  -> expressible-value?

(define apply-closure
  (lambda (formals body env args)
    (let ([new-env (extended-env formals args env)])
      (eval-ast body new-env))))

]

@section{parser.ss}
@racketblock[
(require racket/match)

(require "ast.ss")

(provide
  parse)

(define *keywords*
  '(ifte assume function recursive))

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
     
     [(list 'ifte a b c)  (ifte (parse a) (parse b) (parse c))]
     
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

     [(list
        'recursive
        (list
          (list
            (? id? f)
            (and formals (list (? id? x) ...))
            fbody) ...)
        body)
      (let* ([fast (map parse fbody)]
             [fbinds (map make-fbind f formals fast)])
        (recursive fbinds (parse body)))]

     [(list rator rands ...)
      (let* ([rator (parse rator)]
             [rands (map parse rands)])
        (app rator rands))]
     
     [_ (error 'parse "don't know how to parse ~a" d)])))

]

@section{run.ss}
@racketblock[
(require "ast.ss")
(require "env-rec.ss")
(require "semantic-domains.ss")
(require "eval-ast.ss")
(require "parser.ss")

(provide
 run
 go
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

(define go
  (lambda (e)
    (run (parse e))))

]
