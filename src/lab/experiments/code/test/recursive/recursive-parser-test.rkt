#lang racket/base

(require rackunit "recursive-parser.ss" "recursive-ast.ss")

(provide parse-test)

(define parse-test
  (test-suite "test-for-parser"

(check-equal? (parse 4) (number 4) "parse-number")
(check-equal? (parse 'x) (id-ref 'x) "parse-id")

(check-equal?
 (parse '(ifte 3 4 8))
 (ifte (number 3) (number 4) (number 8))
 "parse-ifte")


(check-equal?
 (parse '(function (x y) 4))
 (function '(x y) (number 4))
 "parse-function")


(check-equal?
  (parse '(assume ([x 3]) 6))
  (assume (list (make-bind 'x (number 3))) (number 6))
  "parse-assume")


(check-equal?
  (parse '(recursive ([f (x y) x] [g (m n) 5]) 9))
  (recursive
    (list
      (make-fbind 'f '(x y) (id-ref 'x))
      (make-fbind 'g '(m n) (number 5)))
    (number 9))
  "parse-recursive")


(check-equal?
  (parse '(recursive () 9))
  (recursive
    (list)
    (number 9))
  "parse-empty-recursive")


(check-equal?
  (parse '(x y))
  (app (id-ref 'x)
       (list (id-ref 'y)))
  "parse-app")


(check-exn exn? (lambda () (parse "hello")) "parse-string-error")
(check-exn exn? (lambda () (parse '#(1 2))) "parse-vector-error")
(check-exn exn? (lambda () (parse '(1 . 2)) "parse-cons-error"))
(check-exn exn? (lambda () (parse '()) "parse-empty-error"))
))

(require rackunit/text-ui)                    
(run-tests parse-test)
