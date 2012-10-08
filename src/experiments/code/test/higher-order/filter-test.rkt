#lang racket/base

(require rackunit "filter.ss")

(provide filter-test)

(define filter-test
  (test-suite "test-for-filter.ss"

	      (check-equal? (list-count boolean? '(#t 2 3 4 #f)) 2)
	      (check-equal? (list-count number? '(#t 2 3 4 #f)) 3)

  )
)
 
(require rackunit/text-ui)
(run-tests filter-test)


