#lang racket/base

(require rackunit "arithmetic-eval.ss" "arithmetic-ast.ss" "arithmetic-op.ss" "arithmetic-semanticdomain.ss")

(provide eval-test)

(define eval-test
  (test-suite "test-for-eval-ast.ss"
        
        (check-equal? (eval-ast (number 5)) 5)
	(check-equal? (eval-ast (prim-app '+ (list (number 5) (number 7)))) 12)
	(check-exn exn? (lambda () (eval-ast (prim-app '/ (list (number 5) (number 0))))) "Divide by zero")

   )
)

(require rackunit/text-ui)
(run-tests eval-test)
