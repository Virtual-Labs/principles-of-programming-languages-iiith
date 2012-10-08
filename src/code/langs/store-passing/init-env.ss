#lang scheme


(provide
  *init-env*)

;;; ===================
;;; Initial Environment
;;; ===================

(require "semantic-domains.ss")
;;; Primitive Procedures
;;; --------------------



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

(define <p
  (prim-proc  <
    (list boolean? number? number?)))

(define <=p
  (prim-proc   <=
    (list boolean? number? number?)))

(define eq?p
  (prim-proc eq?
    (list boolean? expressible-value? expressible-value?)))

(define 0?p
  (prim-proc zero?
    (list boolean? number?)))

(define *init-env*
  (extended-env
   '(+ - * / < <= eq? 0?)
   (list +p -p *p /p <p <=p eq?p 0?p)
   (empty-env)))
