#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "programming-4"]{Programming}

@local-table-of-contents[]

@section{ast.ss}

@racketblock[
(require eopl/eopl)

(provide
  ast
  ast?
  number
  boolean
  *op-symbols*
  op-symbol?
  prim-app)

(define *op-symbols*
  '(+ - * /))
  
  
(define op-symbol?
  (lambda (x)
    (if (memq x *op-symbols*)
      #t
      #f)))
      
(define-datatype ast ast?
  [number (datum number?)]
  [boolean (datum boolean?)]
  [prim-app (op op-symbol?) (rands (list-of ast?))])
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
      [else (parse-error d)])))

(define parse-error
  (lambda (d)
    (error 'parse-error "invalid syntax ~a" d)))
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

(define expressible-value?
  (lambda (thing)
    (or (number? thing)
      (boolean? thing))))

(define nonzero?
  (lambda (n)
    (and (number? n)
      (not (zero? n)))))

(define-struct op (name prim sig))
(define +op   (make-op '+  +   (list number? number? number?)))
(define -op    (make-op '-     -     (list number? number? number?)))
(define *op    (make-op '*     *     (list number? number? number?)))
(define /op    (make-op '/     /     (list number? number? nonzero?)))

(define *ops*
  (list +op -op *op /op ))

(define op-find
  (lambda (opsym)
    (findf (lambda (op)
             (eq? opsym (op-name op)))
           *ops*)))
]

@section{eval-ast.ss}

@racketblock[
(require eopl/eopl)
(require "ast.ss")
(require "op.ss")

(provide
  eval-ast
  number
  boolean
  expressible-value?
  apply-prim-op)

(define eval-ast
  (lambda (a)
    (cases ast a
      [number (datum) datum]
      [boolean (datum) datum]
      [prim-app (op rands)
        (let ([args (map eval-ast rands)])
          (apply-prim-op op args))])))

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

@section{run.ss}

@racketblock[
(provide
  run)

(require "parser.ss")
(require "eval-ast.ss")

(define run
  (lambda (e)
    (eval-ast (parse e))))
]
