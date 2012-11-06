#lang scheme

;;; ============
;;; Environments
;;; ============


;; An environment is a repository of mappings from symbols
;; to values, ie., values *denoted* by identifiers.

;;; Environment abstract data type
;;;

;;; Type predicate
;;; --------------
;;; env? : any/c -> boolean?

;;; lookup-env : [env?  symbol?] -> any/c
;;; lookup-env : throws error if symbol is not in the environment

(provide
  env
  env?
  empty-env
  empty-env?
  extended-env
  extended-env?
  lookup-env
  list-index)

(require eopl/eopl)


;;; An env is a union type of either
;;; * an empty environment OR

;;; * an extended environment consisting of a list of
;;;   symbols, a list of denotable values and an outer
;;;   environment.

(define-datatype env env?
  [empty-env]
  [extended-env
    (syms (list-of symbol?))
    (vals (list-of any/c))
    (outer-env env?)])

;;; empty-env? : env? -> boolean?
(define empty-env?
  (lambda (e)
    (cases env e
      [empty-env () #t]
      [else #f])))

;;; extended-env? : env? -> boolean?
(define extended-env?
  (lambda (e)
    (cases env e
      [empty-env () #f]
      [else #t])))


;;; Returns the loction of the element in a list, -1 if the
;;; element is absent.

;;; list-index : [(listof any/c)  any/c] -> 
(define list-index
  (lambda (ls a)
    (letrec ([loop
               (lambda (ls ans)
                 (cond
                   [(null? ls) -1]
                   [(eq? (first ls) a) ans]
                   [#t (loop (rest ls) (+ 1 ans))]))])
      (loop ls 0))))

;;; lookup-env: [env?  symbol?] -> any/c
;;; lookup-env: throws "unbound identifier" error
(define lookup-env
  (lambda (e x)
    (cases env e
      [empty-env ()
        (error
          'lookup-env
          "unbound identifier ~a" x)]
      [extended-env (syms vals outer-env)
        (let ([j (list-index syms x)])
          (cond
            [(= j -1) (lookup-env outer-env x)]
            [#t (list-ref vals j)]))])))



