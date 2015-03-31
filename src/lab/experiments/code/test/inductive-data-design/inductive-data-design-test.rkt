#lang racket/base

(require rackunit "inductive-data-design.ss")

(provide inductive-data-design-test)

(define inductive-data-design-test
  (test-suite "inductive-data-design-test.ss"

   (check-equal? (z) '())
   (check-equal? (s (s (s (z)))) '(a a a))
   (check-equal? (s-pred (s (s (s (z))))) '(a a))

)
)

(require rackunit/text-ui)
(run-tests inductive-data-design-test)