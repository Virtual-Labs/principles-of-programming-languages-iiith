#lang racket/base

(require rackunit "arithmetic-parser.ss" "arithmetic-eval.ss" "arithmetic-ast.ss" "arithmetic-op.ss" "arithmetic-semanticdomain.ss")

(provide parser-test)

(define parser-test
  (test-suite "test-for-parser.ss"

(check-equal? (number 5)   (parse 5) "parse5")

(check-equal? (prim-app '+ (list (number 3)))
              (parse '(+ 3)) "parse+")

(check-equal? (prim-app '/ (list (number 3) (number 2)))
              (parse '(/ 3 2)) "parse/")

(check-exn exn? (lambda () (parse 'x)) "parse-error-x")

(check-exn exn? (lambda () (parse '())) "parse-error-nil")
))

(require rackunit/text-ui)
(run-tests parser-test)



