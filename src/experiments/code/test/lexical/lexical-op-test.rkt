#lang racket/base

(require rackunit "lexical-ast.ss" "lexical-op.ss" "lexical-semanticdomain.ss")

(provide op-test)

(define op-test
  (test-suite "test-for-lexical-op.ss"

;;nonzero?
(check-equal? (nonzero? 1) #t)
(check-equal? (nonzero? 0) #f)

;;op-find
(check-equal? (op-name (op-find '+)) '+)
(check-equal? (op-name (op-find '*)) '*)
(check-equal? (op-name (op-find '/)) '/)
(check-equal? (op-name (op-find '-)) '-)
(check-equal? (op-name (op-find 'eq?)) 'eq?)
(check-equal? (op-name (op-find '<)) '<)
(check-equal? (op-name (op-find '<=)) '<=)
(check-equal? (op-name (op-find '0?)) '0?)

))

(require rackunit/text-ui)
(run-tests op-test)
