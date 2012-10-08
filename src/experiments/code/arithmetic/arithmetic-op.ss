#lang racket


(provide
  *ops*
  op-name
  op-prim
  op-sig
  op-find)
  
(require eopl/eopl)
(require "arithmetic-ast.ss")
(require "arithmetic-semanticdomain.ss")


;;; nonzero? : any/c -> boolean?
(define nonzero?
  (lambda (n)
    (and (number? n)
      (not (zero? n)))))

;;; Operators
;;; =========
(define-struct op (name prim sig))
(define +op   (make-op '+  +   (list number? number? number?)))
(define -op    (make-op '-     -     (list number? number? number?)))
(define *op    (make-op '*     *     (list number? number? number?)))
(define /op    (make-op '/     /     (list number? number? nonzero?)))

(define *ops*
  (list +op -op *op /op))

(define op-find
  (lambda (opsym)
    (findf (lambda (op)
             (eq? opsym (op-name op)))
           *ops*)))
