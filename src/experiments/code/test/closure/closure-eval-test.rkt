#lang racket/base

(require rackunit "closure-env.ss" "closure-ast.ss" "closure-semanticdomain.ss" "closure-eval.ss")

(provide closure-eval-test)

(define e1
  (extended-env '(x y z) '(1 2 3) (empty-env)))

(define closure-eval-test
  (test-suite "test-for-closure-eval.ss"

(let ([n5 (number 5)]
      [n7 (number 7)]
      [bt (boolean #t)]
      [id1 (id-ref 'x)]
      [id2 (id-ref 'y)]
      [id3 (id-ref 'z)])
  (check-equal? (eval-ast n5 e1) 5 "eval-ast: n5 test")
  (check-equal? (eval-ast bt e1) #t "eval-ast: bt test")
  (check-equal? (eval-ast id1 e1) 1 "eva-ast: x test")
  (check-equal? (eval-ast id2 e1) 2 "eval-ast: y test"))

(check-equal?
  (eval-ast
    (app (function '(x) (id-ref 'x)) (list (number 3))) e1)
  3 "eval-ast: app-function test")

(check-exn exn? (lambda () (eval-ast (app (number 5) (list (number 3))) (empty-env))))
  )
)
 
(require rackunit/text-ui)
(run-tests closure-eval-test)



