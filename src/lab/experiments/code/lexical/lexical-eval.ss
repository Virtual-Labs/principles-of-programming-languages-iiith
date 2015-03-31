#lang scheme

;;; ==================================
;;; Evaluator for the LEXICAL language
;;; ==================================
  
(require eopl/eopl)
(require "lexical-ast.ss")
(require "lexical-op.ss")
(require "lexical-env.ss")
(require "lexical-semanticdomain.ss")


(provide
   eval-ast)

;;; eval-ast : [ast? env?]-> expressible-value?
;;; eval-ast :  throws error 
(define eval-ast
  (lambda (a env)
    (cases ast a
      [number (datum) datum]
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

