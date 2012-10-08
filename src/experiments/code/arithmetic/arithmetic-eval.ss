;;; POPL Lec 11 of 2010-09-21
;;; =========================
;;; =====================================
;;; Evaluator for the ARITHMETIC language
;;; =====================================

;;; Semantic Values
;;; ===============

;;; expressible-value ::=  number | boolean


#lang racket

(require eopl/eopl)
(require "arithmetic-ast.ss")
(require "arithmetic-semanticdomain.ss")
(require "arithmetic-op.ss")

(provide
  eval-ast
  number
  expressible-value?
  apply-prim-op)


;;; eval-ast : ast? -> expressible-value?
;;; eval-ast :  throws error 
(define eval-ast
  (lambda (a)
    (cases ast a
      [number (datum) datum]
      [prim-app (op rands)
        (let ([args (map eval-ast rands)])
          (apply-prim-op op args))])))

(define match-sig?
  (lambda (sig? val)
    (sig? val)))

;;; apply-prim-op : [op-symbol? (listof expressible-value?)] -> expressible-value?

;;; apply-prim-op : throws error when number or type of args
;;; do not match the signature of op identified by opsym.

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

      
