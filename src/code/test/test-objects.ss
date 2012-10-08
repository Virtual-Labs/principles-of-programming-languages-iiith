#lang racket

(require eopl/eopl)
(require rackunit)
(require rackunit/text-ui)
(require "../objects.ss")

(provide test-objects)

(define test-objects
(lambda ()
 	(define p1 (make-point 4 5))
	(define p1.get (first p1))
	(define p1.set (second p1))
	(run-tests
	(test-suite "objects-test"

	(test-case "get-test"
	(check-equal? (p1.get) '(4 5))
	(check-not-equal? (p1.get) '(5 4))

	(test-case "set-test"
	(check-equal? (p1.set 8 10) (void))
	(check-equal? (p1.get) '(8 10))
	(check-not-equal? (p1.get) '(10 8)))
) 'normal))))
