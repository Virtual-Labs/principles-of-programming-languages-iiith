#lang racket

(require eopl/eopl)

(provide list-reduce)

;;; Implementation
  (define list-reduce
   (lambda (seed bop)
    (lambda (ls)
     (cond
      [(null? ls) seed]
      [else (bop
              (first ls)
              ((list-reduce seed bop)
               (rest ls)))]))))