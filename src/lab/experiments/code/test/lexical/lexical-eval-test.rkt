#lang racket/base

(require rackunit "lexical-eval.ss" "lexical-ast.ss" "lexical-op.ss" "lexical-env.ss" "lexical-semanticdomain.ss")

(provide eval-test)

(define-simple-check (check-eval thing1 thing2)
   (eval-ast thing1 thing2))

(define e1
  (extended-env '(x y z) '(1 2 3) (empty-env)))

(define e2
  (extended-env '(w x) '(5 6) e1))

(define eval-test
  (test-suite "test-for-lexical-eval.ss"

(check-equal? 11 (eval-ast (prim-app '+ (list (id-ref 'x) (id-ref 'w))) e2)) 
(check-equal? 8 (eval-ast (prim-app '+ (list (id-ref 'x) (id-ref 'y))) e2)) 
(check-equal? (eval-ast (assume (list (make-bind 'x (number 8))
                          (make-bind 'y (number 7)))
                    (prim-app '+ (list (id-ref 'x) (id-ref 'y)))) e2) 15)
(check-equal? (eval-ast (assume (list (make-bind 'x (number 8))
                         (make-bind 'y (number 7)))
                  (prim-app '+ (list (id-ref 'x) (id-ref 'w)))) e2) 13)
(check-equal?  (eval-ast (id-ref'w) e2) 5) 

))

(require rackunit/text-ui)
(run-tests eval-test)
