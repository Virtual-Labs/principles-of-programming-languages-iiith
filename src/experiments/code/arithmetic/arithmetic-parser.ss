#lang racket

;;; ===================================
;;; Parser for the ARITHIMETIC language
;;; ===================================

;;; concrete syntax
;;; ===============
;;; exp ::= <number> | <boolean> | (<op> exp ...)
;;; op  ::= one of *op-symbols*

(require "arithmetic-ast.ss")

(provide
  parse)

;;; parse
;;; =====
;;; parse : any/c -> ast?
;;; parse : throws parse-error when input
;;;         does not parse.

(define parse
  (lambda (d)
    (cond
      [(number? d) (number d)]
      [(and
         (list? d)
         (not (null? d))
         (memq (first d) *op-symbols*))
       (prim-app (first d)
         (map parse (rest d)))]
      [else (parse-error d)])))

;;; .


;;; parse-error
;;; ===========
;;; parse-error : any/c -> void?
(define parse-error
  (lambda (d)
    (error 'parse-error "invalid syntax ~a" d)))
;;; .


