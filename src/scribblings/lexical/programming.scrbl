#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "programming-6"]{Programming}

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
  prim-app
  assume
  *op-symbols*
  make-bind
  bind-id
  bind-ast)

(define-datatype ast ast?
  [number (datum number?)]
  [boolean (datum boolean?)]
  [prim-app (op op-symbol?) (rands (list-of ast?))]
  [id-ref (sym id?)]
  [assume (binds  (list-of bind?)) (body ast?)])

(define-datatype bind bind?
  [make-bind (b-id id?) (b-ast ast?)])

(define bind-id
  (lambda (b)
    (cases bind b
      [make-bind (b-id b-ast) b-id])))

(define bind-ast
  (lambda (b)
    (cases bind b
      [make-bind (b-id b-ast) b-ast])))

(define id? symbol?)

(define *op-symbols*
  '(+ - * /
    < <= eq? 0?))

(define op-symbol?
  (lambda (x)
    (if (memq x *op-symbols*)
      #t
      #f)))

]

@section{env.ss}


@racketblock[

(provide
  env
  env?
  empty-env
  extended-env
  lookup-env)

(require eopl/eopl)

(define-datatype env env?
  [empty-env]
  [extended-env
    (syms (list-of symbol?))
    (vals (list-of any/c))
    (outer-env env?)])

(define empty-env?
  (lambda (e)
    (cases env e
      [empty-env () #t]
      [else #f])))

(define extended-env?
  (lambda (e)
    (cases env e
      [empty-env () #f]
      [else #t])))

(define list-index
  (lambda (ls a)
    (letrec ([loop
               (lambda (ls ans)
                 (cond
                   [(null? ls) -1]
                   [(eq? (first ls) a) ans]
                   [#t (loop (rest ls) (+ 1 ans))]))])
      (loop ls 0))))

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
            [#t (list-ref vals j)]))])))
]

@section{op.ss}
@racketblock[

(provide
  *ops*
  op-name
  op-prim
  op-sig
  op-find)

(require eopl/eopl)
(require "ast.ss")
(require "semantic-domains.ss")

(define nonzero?
  (lambda (n)
    (and (number? n)
      (not (zero? n)))))

(define-struct op (name prim sig))
(define +op   (make-op '+  +   (list number? number? number?)))
(define -op    (make-op '-     -     (list number? number? number?)))
(define *op    (make-op '*     *     (list number? number? number?)))
(define /op    (make-op '/     /     (list number? number? nonzero?)))
(define <op    (make-op '<     <     (list boolean? number? number?)))
(define <=op   (make-op '<=    <=    (list boolean? number? number?)))
(define eq?op  (make-op 'eq?   eq?   (list boolean? expressible-value? expressible-value?)))
(define 0?op   (make-op '0?    zero? (list boolean? number?)))

(define *ops*
  (list +op -op *op /op <op <=op eq?op 0?op))

(define op-find
  (lambda (opsym)
    (findf (lambda (op)
             (eq? opsym (op-name op)))
           *ops*)))

]

@section{semantic-domains.ss}

@racketblock[
(provide
  expressible-value?
  denotable-value?)
(define expressible-value?
  (lambda (thing)
    (or (number? thing)
      (boolean? thing))))

(define denotable-value?
  (lambda (thing)
    (or (number? thing)
      (boolean? thing))))

]

@section{eval-ast.ss}

@racketblock[
(require eopl/eopl)
(require "ast.ss")
(require "op.ss")
(require "env.ss")
(require "semantic-domains.ss")


(provide
   eval-ast)

(define eval-ast
  (lambda (a env)
    (cases ast a
      [number (datum) datum]
      [boolean (datum) datum]
      [id-ref (sym) (lookup-env env sym)]
      [prim-app (op rands)
        (let ([args (map
                     (lambda (rand)
                       (eval-ast rand
                                 env))
                     rands)])
          (apply-prim-op op args))]
      [assume (binds body)
        (let* ([ids (map bind-id binds)]
               [asts (map bind-ast binds)]
               [vals (map (lambda (a)
                            (eval-ast a env))
                          asts)]
               [new-env
                (extended-env ids vals env)])
          (eval-ast body new-env))])))

(define match-sig?
  (lambda (sig? val)
    (sig? val)))

(define apply-prim-op
  (lambda (opsym args)
    (let* ([op (op-find opsym)]
           [sig (op-sig op)]
           [args-sig (rest sig)])
      (cond
       [(and
         (= (length args-sig) (length args))
         (andmap match-sig? args-sig args))
        (apply (op-prim op)  args)]
       [#t (error 'apply-prim-op "incorrect number or type of arguments to ~a" opsym)]))))

]

@section{parser.ss}

@racketblock[
(require "ast.ss")
  
  (provide
    parse)
  
  (define parse
    (lambda (d)
      (cond
        [(number? d) (number d)]
        [(boolean? d) (boolean d)]
        [(and
           (list? d)
           (not (null? d))
           (memq (first d) *op-symbols*))
         (prim-app (first d)
           (map parse (rest d)))]
           
        [(? id? x) (id-ref x)]
        
        [(list 'assume
        (list (list (? id? x) e) ...) body)
      (let* ([a (map parse e)]
             [b (map make-bind x a)])
        (assume b (parse body)))]
        
        [else (parse-error d)])))
  
  (define parse-error
    (lambda (d)
      (error 'parse-error "invalid syntax ~a" d)))
      
]
@section{run.ss}

@racketblock[
(provide run)
(require "eval-ast.ss")
(require "ast.ss")
(require "env.ss")
]
