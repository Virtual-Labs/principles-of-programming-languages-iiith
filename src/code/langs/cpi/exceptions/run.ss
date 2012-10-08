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
 *init-env*
 *resume*)


;;; Primitive Procedures
;;; ====================

(define nonzero? (and/c number? (not/c zero?)))
(define answer? (or/c expressible-value? string?))

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

(check-equal?
  (go '(+ 2 (abort 5))) 5 "go-abort")


;;; error cases
(check-equal?
  (go '(+ 3 #t))
  (format "incorrect number or type of arguments to ~a" +))

(check-equal?
  (go '(/ 3 0))
  (format "incorrect number or type of arguments to ~a" /))

(check-equal?
  (go '(5 7))
  (format "application rator is not a proc ~a" (parse '(5 7))))



(check-equal? (go  '(+ 2  (break 3))) "breaking with value 3" "go-break-3")
(check-equal? (*resume*) 5 "go-resume")
(check-equal? (*resume* 4) 6 "go-resume-6")

(check-equal? (go  '(* (+ 2  (break 3)) (break 4))) "breaking with value 3" "go-break2-3")
(check-equal? (*resume*) "breaking with value 4" "go-resume2")
(check-equal? (*resume*) 20 "go-resume3")
(check-equal? (*resume* 8) 40 "go-resume-8")


(check-equal? (go '(throw 5)) "uncaught exception" "throw-uncaught")
(check-equal? (go '(+ 2 (try (* 3 4) v (+ v 7)))) 14 "try0")
(check-equal? (go '(+ 2 (try (+ 3 (throw 7)) v (+ v 4)))) 13 "try1")
(check-equal? (go '(+ 2 (try (+ 3 (throw (* 2 (throw 7)))) v (+ v 4)))) 13 "try2")
(check-equal? (go '(+ 2 (try (+ 3 (throw (* 2 (throw 7)))) v (+ v (throw 6)))))
              "uncaught exception" "try3")

(check-equal? (go '(letcc k (k 3))) 3 "letcc-1")
(check-equal? (go '(letcc k (+ 2 (k 3)))) 3 "letcc-2")
(check-equal? (go '(+ 2 (letcc k (* 3 (k 4))))) 6 "letcc-3")

