#lang scheme

(require "ast.ss")
(require "env-proc.ss")
(require "semantic-domains.ss")
(require "eval-ast.ss")

(provide
 run
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

;;; run: ast? -> expressible-value?

(define run
  (lambda (ast)
    (eval-ast ast *init-env*)))


;;; Unit testing
;;; ============

(require rackunit)

  
(check-equal?
  (run
      (assume (list (make-bind 'a (number 5))
                (make-bind 'b (number 6)))
        (app (id-ref '+)
          (list (id-ref 'a) (id-ref 'b)))))
  11 "run: assume-test")

  
(check-equal?
 (run
  (function                 ; (lambda (x y z) (+ x (* y z)))
   '(x y z)
   (app (id-ref '+)
        (list (id-ref 'x)
              (app (id-ref '*)
                   (list (id-ref 'y) (id-ref 'z)))))))
 7 "run: function-test")
