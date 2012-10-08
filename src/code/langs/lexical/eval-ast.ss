#lang scheme

;;; ==================================
;;; Evaluator for the LEXICAL language
;;; ==================================
  
(require eopl/eopl)
(require "ast.ss")
(require "op.ss")
(require "env.ss")
(require "semantic-domains.ss")


(provide
   eval-ast)

;;; eval-ast : [ast? env?]-> expressible-value?
;;; eval-ast :  throws error 
(define eval-ast
  (lambda (a env)
    (cases ast a
      [number (datum) datum]
      [boolean (datum) datum]
      [id-ref (sym) (lookup-env env sym)]
      [prim-app (op rands)
        (let ([args (map
                     (lambda (rand)
                       (eval-ast rand
                                 env))
                     rands)])
          (apply-prim-op op args))]
      [assume (binds body)
        (let* ([ids (map bind-id binds)]
               [asts (map bind-ast binds)]
               [vals (map (lambda (a)
                            (eval-ast a env))
                          asts)]
               [new-env
                (extended-env ids vals env)])
          (eval-ast body new-env))])))

(define match-sig?
  (lambda (sig? val)
    (sig? val)))

;;; apply-prim-op : [op-symbol? (listof expressible-value?)] -> expressible-value?

;;; apply-prim-op : throws error when number or type of args
;;; do not match the signature of op identified by opsym.

(define apply-prim-op
  (lambda (opsym args)
    (let* ([op (op-find opsym)]
           [sig (op-sig op)]
           [args-sig (rest sig)])
      (cond
       [(and
         (= (length args-sig) (length args))
         (andmap match-sig? args-sig args))
        (apply (op-prim op)  args)]
       [#t (error 'apply-prim-op "incorrect number or type of arguments to ~a" opsym)]))))


(require rackunit)

(define-simple-check (check-eval thing1 thing2)
   (eval-ast thing1 thing2))
(define e1
  (extended-env '(x y z) '(1 2 3) (empty-env)))
(define e2
  (extended-env '(w x) '(5 6) e1))

(check-equal? 11 (eval-ast (prim-app '+ (list (id-ref 'x) (id-ref 'w))) e2)) 
(check-equal? 8 (eval-ast (prim-app '+ (list (id-ref 'x) (id-ref 'y))) e2)) 
(check-equal? (eval-ast (assume (list (make-bind 'x (number 8))
                          (make-bind 'y (number 7)))
                    (prim-app '+ (list (id-ref 'x) (id-ref 'y)))) e2) 15)
(check-equal? (eval-ast (assume (list (make-bind 'x (number 8))
                          (make-bind 'y (number 7)))
                    (prim-app '+ (list (id-ref 'x) (id-ref 'w)))) e2) 13)
(check-equal?  (eval-ast (id-ref'w) e2) 5) 

