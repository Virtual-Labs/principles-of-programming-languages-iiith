#lang racket/base

(require rackunit "factorial.ss")

(provide factorial-test)

(define factorial-test
  (test-suite "test-for-factorial.ss"

         (check-equal? (! 3) 6)

)
)

(require rackunit/text-ui)
(run-tests factorial-test)
