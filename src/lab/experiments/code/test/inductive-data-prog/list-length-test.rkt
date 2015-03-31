#lang racket/base

(require rackunit "list-length.ss")

(provide list-length-test)

(define list-length-test
  (test-suite "test-for-list-length.ss"
         (check-eq? (list-length '()) 0)
         (check-eq? (list-length '(1 2 3 4)) 4)
         (check-eq? (list-length '(4 6 7)) 3)
        
)
)

(require rackunit/text-ui)
(run-tests list-length-test)