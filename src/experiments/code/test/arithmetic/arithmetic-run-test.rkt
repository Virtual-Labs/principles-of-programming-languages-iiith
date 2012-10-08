#lang racket/base
 
(require rackunit "arithmetic-eval.ss" "arithmetic-ast.ss" "arithmetic-op.ss" "arithmetic-semanticdomain.ss" "arithmetic-parser.ss" "arithmetic-run.ss")

(provide arithmetic-run-test)

(define arithmetic-run-test
  (test-suite "test-for-run.ss"
        
	(check-equal? 5 (run 5))
	(check-equal? 7 (run '(+ 3 4)))
	(check-equal? 14 (run '(* (+ 3 4) 2)))
	(check-exn  exn?
            (lambda () (run '(+ *))))
   )
)

(require rackunit/text-ui)
(run-tests arithmetic-run-test)
