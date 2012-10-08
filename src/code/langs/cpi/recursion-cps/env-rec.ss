#lang scheme

;;; ====================================
;;; Recursive Environments (CPS version)
;;; ====================================


;;; An environment is a repository of mappings from symbols
;;; to values, ie., values *denoted* by identifiers.

;;; Environment abstract data type
;;;

;;; Type predicate
;;; --------------
;;; env? : any/c -> boolean?

(provide
  env
  env?
  empty-env
  extended-env
  extended-rec-env
  lookup-env/k

  proc
  prim-proc
  closure
  
  proc?
  prim-proc?
  closure?
  )

(require eopl/eopl)
(require "ast.ss")

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


;;; Searches for the index (position) of the
;;; element in a list.  Invokes the failure
;;; continuation if the element is absent.
;;; Invokes the success continuation with the
;;; index if the element is in the list.

;;; list-index/k :
;;;    [(listof 'a) 'a (K nat?) (K)]
;;;    -> answer?

(define list-index/k
  (lambda (ls a succ fail)
    (letrec
     ([loop
        (lambda (ls ans)
          (cond
            [(null? ls) (fail)]
            [(eq? (first ls) a) (succ ans)]
            [#t (loop (rest ls) (+ 1 ans))]))])
     (loop ls 0))))

;;; lookup-env/k:
;;; [env?  symbol? (K any/c) (K)] ->  
(define lookup-env/k
  (lambda (e x succ fail)
    (cases env e
      [empty-env () (fail)]
      [extended-env (syms vals outer-env)
        (list-index/k syms x
          (lambda (j)
            (succ (list-ref vals j)))
          (lambda ()
            (lookup-env/k outer-env x succ fail)))]
      
      [extended-rec-env
       (fsyms lformals bodies outer-env)
        (list-index/k fsyms x
          (lambda (j)
            (let ([formals
                    (list-ref lformals j)]
                  [body (list-ref bodies j)])
              (succ (closure formals body e))))
          (lambda ()
            (lookup-env/k outer-env x succ fail)))])))
            
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


;;; Unit testing
;;; ============
(require rackunit)

(check-pred env? (empty-env) "env?-empty-env")
(check-pred empty-env? (empty-env) "empty-env?-empty-env")
(check-equal? "error"
  (lookup-env/k (empty-env) 'a
    (lambda (j) j)
    (lambda () "error")))

(define e1
  (extended-env '(x y z) '(1 2 3) (empty-env)))

(check-pred env?  e1 "env?-extended-env")
(check-pred extended-env? e1 "extended-env?-extended-env")

(check-equal? 1
  (lookup-env/k e1 'x
    (lambda (ans) ans)
    (lambda () "error")) "lookup-e1-x")

(check-equal? 2
  (lookup-env/k e1 'y
    (lambda (ans) ans)
    (lambda () "error")) "lookup-e1-y")

(check-equal? "error"
  (lookup-env/k e1 'a
    (lambda (ans) ans)
    (lambda () "error")) "lookup-e1-a")

(define e2
  (extended-env '(w x) '(5 6) e1))

(define lookup-env
  (lambda (env sym)
    (lookup-env/k env sym
      (lambda (x) x)
      (lambda () "error"))))

(check-equal? 5 (lookup-env e2 'w) "lookup-e2-w")
(check-equal? 6 (lookup-env e2 'x) "lookup-e2-x")
(check-equal? 2 (lookup-env e2 'y) "lookup-e2-y")
(check-equal? 3 (lookup-env e2 'z) "lookup-e2-z")
(check-equal? "error" (lookup-env e2 'a) "lookup-e2-a")

(define even-body
  (ifte
    (app (id-ref '0?) (list (id-ref 'n)))
    (boolean #t)
    (app
      (id-ref 'odd?)
      (list (app
              (id-ref '-)
              (list (id-ref 'n) (number 1)))))))

(define odd-body
  (ifte (app (id-ref '0?) (list (id-ref 'n)))
    (boolean #f)
    (app (id-ref 'even?)
      (list (app (id-ref '-)
              (list (id-ref 'n) (number 1)))))))

(define e3
  (extended-rec-env
    '(even? odd?)
    '((n) (n))
    (list even-body odd-body)
    e2))

(check-equal? 6 (lookup-env e3 'x))

(check-equal?
 (closure '(n) even-body e3)
 (lookup-env e3 'even?) "lookup-env-even? test")









    
     
     
   
                    










    
    
    
  

