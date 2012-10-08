;;; POPL Lec 10 of 2010-09-17
;;; ==========================================================
;;; Abstract Syntax Specification of a language for arithmetic
;;; ==========================================================
;;; ast ::= num-ast | bool-ast | prim-app-ast


#lang racket

(require eopl/eopl)

(provide
  ast
  ast?
  number
  *op-symbols*
  op-symbol?
  prim-app)

(define *op-symbols*
  '(+ - * /))

;;; op-symbol? : symbol? -> bool
(define op-symbol?
  (lambda (x)
    (if (memq x *op-symbols*)
      #t
      #f)))

(define-datatype ast ast?
  [number (datum number?)]
  [prim-app (op op-symbol?) (rands (list-of ast?))])