#lang racket/base

(require rackunit "arithmetic-ast.ss" "arithmetic-op.ss" "arithmetic-semanticdomain.ss")

(provide op-test)

(define op-test
  (test-suite "test-for-op.ss"
        
	(check-true (op-symbol? '<))
	(check-true (op-symbol? '*))
	(check-true (op-symbol? '+))
	(check-true (op-symbol? '/))
   )
)

(require rackunit/text-ui)
(run-tests op-test)
