#lang racket

(require lang/htdp-advanced)

(require "filter.ss")

(provide list-count)

;;; Implementation
  (define list-count
     (lambda (pred? ls)
          (length (list-filter pred? ls))))

;;test cases
(list-count boolean? '(#t 2 3 4 #f))

;(check-equal? (count boolean? '(#t 2 3 4 #f)) 2)
;(check-equal? (count number? '(#t 2 3 4 #f)) 3)