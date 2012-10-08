#lang racket

(require lang/htdp-advanced)

(provide list-sum)

  (define list-sum
   (lambda (ls)
    (cond
     [(null? ls) 0]
     [else (+
             (first ls)(list-sum (rest ls)))])))
  
;;; test cases
  (list-sum '())
  (list-sum '(1))
  (list-sum '(1 2 3))