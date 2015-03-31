#lang racket

(require eopl/eopl)

(provide
   z
   z?
   s
   s?
   nat?
   s-pred)

;;; z : () -> z? 
(define (z) '())

;;; s : nat? -> s?
(define (s n)
   (cons 'a n))

;;; z? : any/c -> bool
(define (z? thing)
  (eq? thing z))

;;; s? : any/c -> bool
 (define (s? thing)
  (and (list? thing)
    (eq? (first thing) 's)
    (nat? (rest thing))))

;;; nat? = (or/c z? s?)
(define nat? (or/c z? s?))

     
;;; prev : s? -> nat?
(define (s-pred a)
  (rest a))

