#lang racket

;;; ============================================
;;; Top level driver for the ARITHMETIC language
;;; ============================================

;;; run
;;; ===
;;; run : any -> expressible-value?
;;; run : throws parse error if input does not parse.
;;; run : throws apply-prim-op error if prim operator is
;;;       not given the right # or types of arguments.

(provide
  run)

(require "parser.ss")
(require "eval-ast.ss")

(define run
  (lambda (e)
    (eval-ast (parse e))))


;;; Unit testing
;;; ============
(require rackunit)

(check-equal? 5 (run 5) "run 5")
(check-equal? #t (run #t) "run #t")
(check-equal? 7 (run '(+ 3 4)) "run (+ 3 4)")
(check-equal? #f (run '(0? 7)) "run (0? 7)")
(check-equal? 14 (run '(* (+ 3 4) 2)) "run (* (+ 3 4) 2)")
(check-exn  exn?
            (lambda () (run '(+ *)))
            "parse-error: (+ *)")

(check-exn  exn?
            (lambda () (run '(0? #t)))
            "apply-prim-app-error: (0? #t)")


