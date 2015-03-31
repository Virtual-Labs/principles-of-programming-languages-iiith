#lang mzscheme

(require eopl/eopl)

(provide fact-acc
	 fact-a)

  (define fact-acc
   (lambda (n a)
    (cond
     [(zero? n) a]
     [else (fact-acc (sub1 n) (* n a))])))

   (define fact-a
   (lambda (n)
    (fact-acc n 1)))
