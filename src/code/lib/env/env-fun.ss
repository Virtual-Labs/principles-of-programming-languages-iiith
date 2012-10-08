#lang scheme

;;; ================================================
;;; Procedural implementation of the environment adt
;;; ================================================

(define env? procedure?)

(define empty-env
  (lambda ()
    (lambda (x)
      (error 'empty-env "~x not found" x))))

(define extended-env
  (lambda (syms vals env)
    (lambda (x)
      (let ([j (list-index syms x)])
        (cond
          [(=  j -1) (lookup-env env x)]
          [else (list-ref vals j)])))))

(define lookup-env
  (lambda (env x)
    (env x)))