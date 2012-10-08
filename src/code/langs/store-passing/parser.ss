#lang scheme

;;; =================================
;;; Parser for the RECURSION language
;;; =================================


(require racket/match)

(require "ast.ss")

(provide
  parse)

(define *keywords*
  '(ifte assume function recursive ref deref setref))

(define id?
  (lambda (x)
    (and
     (symbol? x)
     (not (memq x *keywords*)))))
         

(define parse
  (lambda (d)
    (match d
     [(? number? n) (number n)]
     [(? boolean? b) (boolean b)]
     [(? id? x) (id-ref x)]
     
     [(list 'ifte a b c)  (ifte (parse a) (parse b) (parse c))]
     
     [(list
       'function
       (list (? id? x) ...)
       body)
      (function x (parse body))]
     
     [(list 'assume
        (list (list (? id? x) e) ...) body)
      (let* ([a (map parse e)]
             [b (map make-bind x a)])
        (assume b (parse body)))]

     [(list
        'recursive
        (list
          (list
            (? id? f)
            (and formals (list (? id? x) ...))
            fbody) ...)
        body)
      (let* ([fast (map parse fbody)]
             [fbinds (map make-fbind f formals fast)])
        (recursive fbinds (parse body)))]
     [(list 'ref e)
      (new-ref (parse e))]
     [(list 'deref e)
      (deref (parse e))]
     [(list 'setref e1 e2)
      (setref (parse e1) (parse e2))]
     
     [(list rator rands ...)
      (let* ([rator (parse rator)]
             [rands (map parse rands)])
        (app rator rands))]
     
     [_ (error 'parse "don't know how to parse ~a" d)])))



;;; Unit Testing
;;; ============
(require rackunit)


(check-equal? (parse 4) (number 4) "parse-number")
(check-equal? (parse #t) (boolean #t) "parse-boolean")
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

(check-equal?
 (parse '(ref 5))
 (new-ref (number 5)))

(check-equal?
 (parse '(deref 5))
 (deref (number 5)))

(check-equal?
 (parse '(setref 5 7))
 (setref (number 5) (number 7)))

(check-exn exn? (lambda () (parse "hello")) "parse-string-error")
(check-exn exn? (lambda () (parse '#(1 2))) "parse-vector-error")
(check-exn exn? (lambda () (parse '(1 . 2)) "parse-cons-error"))
(check-exn exn? (lambda () (parse '()) "parse-empty-error"))


