#lang racket/base

(require rackunit "list-map.ss")

(provide list-map-test)

(define list-map-test
  (test-suite "test-for-list-map.ss"

      (check-equal? (list-map null? '(2 3 4)) '(#f #f #f))
      (check-equal? (list-map boolean? '(2 3 #t)) '(#f #f #t))

  )
)
 
(require rackunit/text-ui)
(run-tests list-map-test)


