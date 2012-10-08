#lang racket

;;; ===================================
;;; Parser for the ARITHIMETIC language
;;; ===================================

;;; concrete syntax
;;; ===============
;;; exp ::= <number> | <boolean> | (<op> exp ...)
;;; op  ::= one of *op-symbols*

(require "ast.ss")

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
      [(boolean? d) (boolean d)]
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


;;; Unit testing
;;; ============
(require rackunit)

(check-equal? (number 5)   (parse 5) "parse5")

(check-equal? (boolean #t) (parse #t) "parse#t")

(check-equal? (prim-app '+ (list (number 3)))
              (parse '(+ 3)) "parse+")

(check-equal? (prim-app '/ (list (number 3) (boolean #t)))
              (parse '(/ 3 #t)) "parse/")

(check-exn exn? (lambda () (parse 'x)) "parse-error-x")

(check-exn exn? (lambda () (parse '())) "parse-error-nil")






