#lang racket/base

(require rackunit "recursive-ast.ss" "recursive-env.ss" "recursive-semanticdomain.ss" "recursive-eval.ss")

(provide eval-test)

(define e1
  (extended-env '(x y z) '(1 2 3) (empty-env)))

(define e2
  (extended-env '(w x) '(5 6) e1))

(define eval-test
  (test-suite "recursive-evaluator"

(let ([n5 (number 5)]
      [n7 (number 7)]
      [id1 (id-ref 'x)]
      [id2 (id-ref 'y)]
      [id3 (id-ref 'z)])
  (check-equal? (eval-ast n5 e1) 5 "eval-ast: n5 test")
  (check-equal? (eval-ast id1 e1) 1 "eva-ast: x test")
  (check-equal? (eval-ast id2 e1) 2 "eval-ast: y test"))
  (check-equal? (eval-ast (id-ref 'w) e2) 5)

))

(require rackunit/text-ui)
(run-tests eval-test)