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

(require "arithmetic-parser.ss")
(require "arithmetic-eval.ss")

(define run
  (lambda (e)
    (eval-ast (parse e))))


