#lang mzscheme

(require lang/htdp-advanced)

(provide list-length)

  (define list-length
   (lambda (ls)
    (cond
     [(null? ls) 0]
     [else (+ 1
             (list-length (rest ls)))])))
  
;;; test cases
  (list-length '())
  (list-length '(a b c))