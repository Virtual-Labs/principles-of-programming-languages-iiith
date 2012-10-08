#lang racket

(provide make-point)

	(define make-point
	 (lambda (p1 p2) 
	  (let ([x p1] [y p2]) 
	   (let ([get (lambda ()
		       (list x y))] 
		 [set (lambda (v1 v2) 
			 (set! x v1) 
			 (set! y v2))]
		)   
	    (list get set)))))

