#lang racket/base

(require rackunit "environment.ss")

(provide lookup-test e1 e2)

(define e1
  (extended-env '(x y z) '(1 2 3) (empty-env)))

(define e2
  (extended-env '(w x) '(5 6) e1))

(define lookup-test
  (test-suite "test-for-lookup.ss"

(check-pred env? (empty-env) "env?-empty-env")
(check-exn exn? (lambda () (lookup-env (empty-env) 'a)) "lookup-empty-env-a")

(check-pred env?  e1 "env?-extended-env")

(check-equal? 1 (lookup-env e1 'x) "lookup-e1-x")
(check-equal? 2 (lookup-env e1 'y) "lookup-e1-y")
(check-exn exn? (lambda () (lookup-env e1 'a)) "lookup-e1-a")

(check-equal? 5 (lookup-env e2 'w) "lookup-e2-w")
(check-equal? 6 (lookup-env e2 'x) "lookup-e2-x")
(check-equal? 2 (lookup-env e2 'y) "lookup-e2-y")
(check-equal? 3 (lookup-env e2 'z) "lookup-e2-z")
(check-exn exn? (lambda () (lookup-env e2 'a)) "lookup-e2-a")

  )
)
 
(require rackunit/text-ui)
(run-tests lookup-test)






