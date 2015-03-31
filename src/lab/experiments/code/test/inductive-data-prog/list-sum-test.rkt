#lang racket/base

(require rackunit "list-sum.ss")

(provide list-sum-test)

(define list-sum-test
  (test-suite "test-for-list-sum.ss"

     (check-eq? (list-sum '()) 0)
     (check-eq? (list-sum '(1)) 1)
     (check-eq? (list-sum '(1 2 3)) 6)
        
)
)

(require rackunit/text-ui)
(run-tests list-sum-test)

