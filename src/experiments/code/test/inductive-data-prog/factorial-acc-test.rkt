#lang racket/base

(require rackunit "factorial-acc.ss")

(provide factorial-acc-test)

(define factorial-acc-test
  (test-suite "test-for-factorial-acc.ss"

         (check-equal? (fact-a 3) 6)

)
)

(require rackunit/text-ui)
(run-tests factorial-acc-test)
