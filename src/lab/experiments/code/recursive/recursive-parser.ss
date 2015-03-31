#lang scheme

;;; =================================
;;; Parser for the RECURSION language
;;; =================================


(require racket/match)

(require "recursive-ast.ss")

(provide
  parse)

(define *keywords*
  '(ifte assume function recursive))

(define id?
  (lambda (x)
    (and
     (symbol? x)
     (not (memq x *keywords*)))))
         

(define parse
  (lambda (d)
    (match d
     [(? number? n) (number n)]
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

     [(list rator rands ...)
      (let* ([rator (parse rator)]
             [rands (map parse rands)])
        (app rator rands))]
     
     [_ (error 'parse "don't know how to parse ~a" d)])))



