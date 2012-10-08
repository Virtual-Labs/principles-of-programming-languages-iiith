#lang racket

(require lang/htdp-advanced)

(provide list-map)

(define list-map
  (lambda (f ls)
    (cond
     [(null? ls) '()]
     [else (cons (f (first ls)) (list-map f (rest ls)))])))

