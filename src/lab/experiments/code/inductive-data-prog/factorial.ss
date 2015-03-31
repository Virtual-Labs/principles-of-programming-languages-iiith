#lang mzscheme

(require eopl/eopl)

(provide fact)

  (define fact
   (lambda (n)
    (cond
     [(zero? n) 1]
     [else (* n (fact (- n 1)))])))
  



