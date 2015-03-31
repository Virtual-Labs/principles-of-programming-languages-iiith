#lang scheme

;;; ================================
;;; Top-level setup for the language
;;; ================================

(require "recursive-ast.ss")
(require "recursive-env.ss")
(require "recursive-semanticdomain.ss")
(require "recursive-eval.ss")
(require "recursive-parser.ss")

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

(define *init-env*
  (extended-env
   '(+ - * /)
   (list +p -p *p /p)
   (empty-env)))

;;; run: ast? -> expressible-value?

(define run
  (lambda (ast)
    (eval-ast ast *init-env*)))

(define go
  (lambda (e)
    (run (parse e))))

