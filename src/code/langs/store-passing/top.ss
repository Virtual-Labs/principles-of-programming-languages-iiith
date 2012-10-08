#lang scheme

;;; ================================
;;; Top-level setup for the language
;;; ================================

(require "run.ss")
(require "parser.ss")

(provide
  go)

(define go
  (lambda (e)
    (run (parse e))))

;;; Unit testing
;;; ============
(require rackunit)


(check-equal?
  (go '(recursive ([f (n) (ifte (0? n) 1 (* n (f (- n 1))))])
         (f 3)))
  6
  "go-factorial")



(check-equal?
  (go
    '(recursive ([even? (n) (ifte (0? n) #t (odd? (- n 1)))]
                 [odd?  (n) (ifte (0? n) #f (even? (- n 1)))])
       (even? 3)))
  #f
  "go-even")

(check-equal?
  (go
    '(assume  ([! (function (n)
                    (assume ([ans (ref 1)]
                             [i (ref n)])
                      (recursive ([loop ()
                                    (ifte
                                      (eq? (deref i) 0)
                                      (deref ans)
                                      (assume ([ignore (setref ans (* (deref ans)
                                                                     (deref i)))])
                                        (assume ([ignore (setref i (- (deref i) 1))])
                                          (loop))))])
                        (loop))))])
       (! 3)))
  6
  "go-factorial-imperative")





