#lang scheme

(require eopl/eopl)

(provide env 
	 env?)

(define-datatype env env?
  [empty-env]
  [extended-env
    (syms (list-of symbol?))
    (vals (list-of any/c))
    (outer-env env?)])
