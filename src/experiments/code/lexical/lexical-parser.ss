#lang racket

(require eopl/eopl)

(require "lexical-ast.ss")
  
    (provide
      parse)
  
    (define parse
      (lambda (d)
        (cond
          [(number? d) (number d)]
          [(and
             (list? d)
             (not (null? d))
             (memq (first d) *op-symbols*))
           (prim-app (first d)
             (map parse (rest d)))]
  
          [(? id? x) (id-ref x)]
  
          [(list 'assume
          (list (list (? id? x) e) ...) body)
        (let* ([a (map parse e)]
               [b (map make-bind x a)])
          (assume b (parse body)))]
  
          [else (parse-error d)])))
  
    (define parse-error
      (lambda (d)
        (error 'parse-error "invalid syntax ~a" d)))