#lang racket/base

(require rackunit "count.ss")

(provide count-test)

(define count-test
  (test-suite "test-for-count.ss"

      (check-equal? (list-count boolean? '(#t 2 3 4 #f)) 2)
      (check-equal? (list-count number? '(#t 2 3 4 #f)) 3)

  )
)
 
(require rackunit/text-ui)
(run-tests count-test)


