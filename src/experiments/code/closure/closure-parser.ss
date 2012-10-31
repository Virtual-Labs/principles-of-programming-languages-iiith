#lang racket

(require eopl/eopl)

 (require "closure-ast.ss")
  
  (provide
    parse)
  
  (define id?
    (lambda (x)
      (and
       (symbol? x)
       (not (memq x *keywords*)))))

  (define *keywords*
    '(lambda boolean number plus minus mult div cond and let define define-datatype))  

  (define parse
    (lambda (d)
      (match d
       [(? number? n) (number n)]
       [(? id? x) (id-ref x)]
  
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
  
       [(list rator rands ...)
        (let* ([rator (parse rator)]
               [rands (map parse rands)])
          (app rator rands))]
  
       [else (error 'parse "don't know how to parse ~a" d)])))

