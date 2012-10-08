#lang racket

(require eopl/eopl)

(provide list-reduce-aux)

;;; Implementation 
  (define list-reduce-aux
   (lambda (seed bop)
    (letrec ([f (lambda (ls)
                 (cond
                  [(null? ls) seed]
                  [else (bop
                          (first ls)
                          (f (rest ls)))]))])
     f)))