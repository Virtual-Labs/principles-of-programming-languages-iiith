#lang scheme

;;; ===================================
;;; Evaluator for the FUNCTION language
;;; ===================================
  
(require eopl/eopl)
(require "ast.ss")
(require "env-rec.ss")
(require "semantic-domains.ss")

(provide
   eval-ast)


;;; We assume the existence of the type answer?, which
;;; denotes the final answer of the entire computation, in
;;; this case, the evaluation of an expression or an error
;;; message.

;;; We define three types of continuations using the
;;; continuation type constructor K.

;;; TYPE (K <type> ...) = <type> ... -> answer?

;;; TYPE Keval? = (K expressible-value?)
;;; TYPE Kdenote? = (K denotable-value?)
;;; TYPE Kerr?  = (K)
;;; TYPE Kevals? = (K (listof expressible-value?))

;;; top-k is the builder for top-level expressible-value
;;; continuations

;;; top-k : [] -> (K any/c)
(define top-k
  (lambda ()
    (lambda (v) ; v is an answer
      v)))

;;; THE top-level continuation
(define *top-k* (top-k))

;;; eval-ast/k : [ast? env? Keval?]-> answer?
(define eval-ast/k
  (lambda (a env k)
    (cases ast a
      [number (datum) (k datum)]
      [boolean (datum) (k datum)]
      
      [id-ref (sym)
        (lookup-env/k env sym k
          (lambda ()
            (*top-k* 
              (format "unbound identifier ~a" sym))))]
      
      [ifte (test then else-ast)
        (eval-ast/k test env
          (lambda (b) 
            (if (boolean? b)
              (eval-ast/k (if b then else-ast) env k)
              (*top-k*
                (format
                  "ifte test is not a boolean ~a" a)))))]
              
      [function (formals body)
        (k (closure formals body env))]
      
      [app (rator rands)
        (eval-ast/k rator env
          (lambda (p)
            (if (proc? p)
              (eval-asts/k rands env
                (lambda (args)
                  (apply-proc/k p args k)))
              (*top-k*
                (format
                  "application rator is not a proc ~a"
                  a)))))]
          
      [assume (binds body)
        (let ([ids  (map bind-id binds)]
              [asts (map bind-ast binds)])
          (eval-asts/k asts env
            (lambda (vals)
              (let ([new-env
                      (extended-env ids vals env)])
                (eval-ast/k body new-env k)))))]

      [recursive (fbinds body)
        (let*
          ([fids (map fbind-id fbinds)]
           [lformals (map fbind-formals fbinds)]
           [bodies (map fbind-body fbinds)]
           [new-env
             (extended-rec-env
               fids lformals bodies env)])
          (eval-ast/k body new-env k))])))

;;; eval-asts/k :
;;; [(listof ast?) env? (K (listof expressible-value?))]
;;; -> answer?

(define eval-asts/k 
  (lambda (asts env k)
    (if (null? asts)
        (k '())
        (eval-ast/k (first asts) env
          (lambda (v)
            (eval-asts/k (rest asts) env
              (lambda (vals)
                (k (cons v vals)))))))))

;;; apply-proc/k :
;;;  [proc? (listof expressible-value?) Keval?]
;;;    -> answer?

(define apply-proc/k
  (lambda (p args k)
    (cases proc p
      [prim-proc (prim sig)
        (apply-prim-proc/k prim sig args k)]
      [closure (formals body env)
        (apply-closure/k formals body env args k)])))



;;; apply-prim-proc :
;;;  [procedure? (listof (or/c procedure? abort?)
;;;     (listof expressible-value?) Keval?] -> answer?

(define apply-prim-proc/k
  (lambda (prim sig args k)
    (let* ([args-sig (rest sig)]) ; argument signatures
      (cond
       [(and
          (= (length args-sig) (length args))
          (andmap match-arg-type args-sig args))
        (k (apply prim  args))]
        ;; notice how the incoming k is dropped
       [#t (*top-k* (format "incorrect number or type of arguments to ~a" prim))]))))

;;; match-arg-type : [procedure? any/c] -> boolean?
(define match-arg-type
  (lambda (arg-type? val)
    (arg-type? val)))

;;; apply-closure/k : [closure? (listof expressible-value?) Keval?]
;;;                  -> answer?

(define apply-closure/k
  (lambda (formals body env args k)
    (let ([new-env (extended-env formals args env)])
      (eval-ast/k body new-env k))))

;;; eval-ast : [ast? env?] -> answer?
(define eval-ast
  (lambda (ast env)
    (eval-ast/k ast env (top-k))))

;;; Unit testing
;;; ============

(require rackunit)

(define e1
  (extended-env '(x y z) '(1 2 3) (empty-env)))

(let ([n5 (number 5)]
      [n7 (number 7)]
      [bt (boolean #t)]
      [id1 (id-ref 'x)]
      [id2 (id-ref 'y)]
      [id3 (id-ref 'z)])
  (check-equal? (eval-ast n5 e1) 5 "eval-ast: n5 test")
  (check-equal? (eval-ast bt e1) #t "eval-ast: bt test")
  (check-equal? (eval-ast id1 e1) 1 "eval-ast: x test")
  (check-equal? (eval-ast id2 e1) 2 "eval-ast: y test"))

;;; testing application
(check-equal?
  (eval-ast
    (app (function '(x) (id-ref 'x)) (list (number 3))) e1)
  3 "eval-ast: app-function test")

;;; testing illegal procedure application

(let ([a (app (number 5) (list (number 3)))])
  (check-equal?
    (eval-ast  a (empty-env))
    (format "application rator is not a proc ~a" a)
    "eval-ast: illegal procedure test"))

(define e2
  (extended-env '(w x) '(5 6) e1))

(check-equal? (eval-ast (id-ref 'w) e2) 5)

