#lang scheme

;;; =================================
;;; Semantic Domains and Environments
;;; =================================

(provide
  expressible-value?
  denotable-value?
  proc
  prim-proc
  closure
  proc?
  prim-proc?
  closure?

  env
  env?
  empty-env
  extended-env
  extended-rec-env
  lookup-env  
  )


;;; Expressible Values (types of values returned by
;;; evaluating an ast)

;;; ========================================

;;; expressible-value ::=
;;;    number | boolean | proc | Ref(expressible-value)

;;; Denotable Values (types of values denoted by
;;; identifiers)
;;; ============================================

;;; denotable-value ::=  expressible-value
;;;

;;; expressible-value? is the set of things that are the
;;; results of evaluation of expressions (asts).

(require eopl/eopl)
(require "ast.ss")
(require (prefix store: "store-list.ss"))
;;; RACKET BUG ???
;;; (require (only-in "store-list.ss" [ref? store:ref?]))

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

;;; prim-proc? : proc? -> boolean?
(define prim-proc?
  (lambda (p)
    (cases proc p
      [prim-proc (prim sig) #t]
      [else #f])))


;;; closure? : proc? -> boolean?
(define closure? 
  (lambda (p)
    (cases proc p
      [closure (formals body env) #t]
      [else #f])))


;;; expressible-value? : any/c -> boolean?
(define expressible-value?
  (or/c number? boolean? proc? store:ref?))

;;; denotable-value? :any/c -> boolean?
(define denotable-value? expressible-value?)




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


;;; Unit testing
;;; ============
(require rackunit)

(check-pred env? (empty-env) "env?-empty-env")
(check-pred empty-env? (empty-env) "empty-env?-empty-env")
(check-exn exn? (lambda () (lookup-env (empty-env) 'a)) "lookup-empty-env-a")

(define e1
  (extended-env '(x y z) '(1 2 3) (empty-env)))

(check-pred env?  e1 "env?-extended-env")
(check-pred extended-env? e1 "extended-env?-extended-env")

(check-equal? 1 (lookup-env e1 'x) "lookup-e1-x")
(check-equal? 2 (lookup-env e1 'y) "lookup-e1-y")
(check-exn exn? (lambda () (lookup-env e1 'a)) "lookup-e1-a")

(define e2
  (extended-env '(w x) '(5 6) e1))

(check-equal? 5 (lookup-env e2 'w) "lookup-e2-w")
(check-equal? 6 (lookup-env e2 'x) "lookup-e2-x")
(check-equal? 2 (lookup-env e2 'y) "lookup-e2-y")
(check-equal? 3 (lookup-env e2 'z) "lookup-e2-z")
(check-exn exn? (lambda () (lookup-env e2 'a)) "lookup-e2-a")

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
      (list (app (id-ref '-) (list (id-ref 'n) (number 1)))))))

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



