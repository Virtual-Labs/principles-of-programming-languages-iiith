#lang racket

(require lang/htdp-advanced)

(provide list-filter)

;;; Implementation
 (define list-filter
   (lambda (pred? ls)
    (cond
     [(null? ls) '()]
     [(pred? (first ls))
     (cons (first ls)
      (filter pred? (rest ls)))]
     [else (filter pred? (rest ls))])))

;;test cases
;(check-equal? (list-filter boolean? '(#t 2 3 4 #f)) '(#t #f))
;(check-equal? (list-filter number? '(#t 2 3 4 #f)) '(2 3 4))

(list-filter boolean? '(#t 2 3 4 #f)) 
(list-filter number? '(#t 2 3 4 #f))
 