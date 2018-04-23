#lang scheme

;;; ======================
;;; Recursive Environments
;;; ======================


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
  extended-rec-env
  extended-rec-env?
  lookup-env

  proc
  prim-proc
  closure
  
  proc?
  prim-proc?
  closure?
  )

(require eopl/eopl)
(require "recursive-ast.ss")

;;; A recursive env is a union type of either
;;; * an empty environment OR

;;; * an extended environment consisting of a list of
;;;   symbols, a list of denotable values and an outer
;;;   environment.

;;; 

(define-datatype env env?
  [empty-env]
  [extended-env
    (syms (list-of symbol?))
    (vals (list-of any/c))
    (outer-env env?)]
  [extended-rec-env
    (fsyms (list-of symbol?))
    (lformals (list-of (list-of symbol?)))
    (bodies (list-of ast?))
    (outer-env env?)])

;;; Subtype Predicates
;;; ==================

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
      [extended-env (syms vals outer-env) #t]
      [else #f])))

;;; extended-rec-env? : env? -> boolean?
(define extended-rec-env?
  (lambda (e)
    (cases env e
      [extended-rec-env (fsyms lformals bodies outer-env) #t]
      [else #f])))


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
            [#t (list-ref vals j)]))]
      [extended-rec-env
       (fsyms lformals bodies outer-env)
        (let ([j (list-index fsyms x)])
          (cond
            [(= j -1)
             (lookup-env outer-env x)]
            [#t
             (let ([formals
                    (list-ref lformals j)]
                   [body (list-ref bodies j)])
                  (closure formals body e))]))])))

;;; We are building a closure during lookup.  For this
;;; reason, the proc adt definition moves into this module.


;;; Procedure ADT
;;; ==============

(define-datatype proc proc?
  [prim-proc
    ;; prim refers to a scheme procedure
    (prim procedure?)
    ;; sig is the signature
    (sig (list-of procedure?))] 
  [closure
    (formals (list-of symbol?))
    (body ast?)
    (env env?)])


;;; Subtype Predicates
;;; ==================

;;; prim? : proc? -> boolean?

(define prim-proc?
  (lambda (p)
    (cases proc p
      [prim-proc (prim sig) #t]
      [else #f])))

(define closure? 
  (lambda (p)
    (cases proc p
      [closure (formals body env) #t]
      [else #f])))


     
   
                    










    
    
    
  
