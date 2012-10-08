#lang mzscheme

(require eopl/eopl)

(provide fact-acc
	 fact)

  (define fact-acc
   (lambda (n a)
    (cond
     [(zero? n) a]
     [else (!/a (sub1 n) (* n a))])))

   (define fact
   (lambda (n)
    (!/a n 1)))
