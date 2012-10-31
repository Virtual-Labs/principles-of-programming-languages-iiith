#lang racket/base

(require rackunit "filter.ss")

(provide filter-test)

(define filter-test
  (test-suite "test-for-filter.ss"

    (check-equal? (list-filter boolean? '(#t 2 3 4 #f)) '(#t #f)) 
    (check-equal? (list-filter number? '(#t 2 3 4 #f)) '(2 3 4))

  )
)
 
(require rackunit/text-ui)
(run-tests filter-test)


