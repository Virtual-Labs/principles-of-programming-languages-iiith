#lang scheme

;;; ================================
;;; Top-level setup for the language
;;; ================================

(require "ast.ss")
(require "env-rec.ss")
(require "semantic-domains.ss")
(require "eval-ast.ss")
(require "parser.ss")

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

(define go
  (lambda (e)
    (run (parse e))))

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
 (closure '(x y z)
   (app (id-ref '+)
     (list (id-ref 'x)
       (app (id-ref '*)
         (list (id-ref 'y) (id-ref 'z)))))
   *init-env*)
 "run: function-test")


;;; (recursive ([even? (n) (if (0? n) #t (odd? (- n 1)))]
;;;             [odd?  (n) (if (0? n) #f (even? (- n 1)))])
;;;    (even? 3))

(check-equal?
 (run
  (recursive
   (list
    (make-fbind 'even?
                '(n)
                (ifte (app (id-ref '0?) (list (id-ref 'n)))
                      (boolean #t)
                      (app (id-ref 'odd?)
                           (list (app (id-ref '-) (list (id-ref 'n) (number 1)))))))

    (make-fbind 'odd?
                '(n)
                (ifte (app (id-ref '0?) (list (id-ref 'n)))
                      (boolean #f)
                      (app (id-ref 'even?)
                           (list (app (id-ref '-) (list (id-ref 'n) (number 1))))))))
   
   (app (id-ref 'even?) (list (number 3)))))
  #f
  "run-recursive-test")


(check-equal?
  (go '(recursive ([f (n) (ifte (0? n) 1 (* n (f (- n 1))))])
         (f 3)))
  6
  "go-factorial")



(check-equal?
  (go
    '(recursive ([even? (n) (ifte (0? n) #t (odd? (- n 1)))]
                 [odd?  (n) (ifte (0? n) #f (even? (- n 1)))])
       (even? 3)))
  #f
  "go-even")
