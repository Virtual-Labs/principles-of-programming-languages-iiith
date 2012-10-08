#lang scheme

;;; ========================================
;;; Run expression in init-env and new-store 
;;; ========================================

(provide
  run)

(require "ast.ss")
(require "init-env.ss")
(require "semantic-domains.ss")
(require "eval-ast.ss")

;;; run: ast? -> expressible-value?
(define run
  (lambda (ast)
    (let-values ([(store val) (eval-ast/new-store ast *init-env*)])
      val)))

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











