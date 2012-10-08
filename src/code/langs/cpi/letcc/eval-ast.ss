#lang scheme

;;; ================================
;;; Evaluator for the LETCC language
;;; ================================


;;; (letcc k <body>) evaluates the body in the lexical
;;; environment that binds the identifier k to the
;;; continuation of the letcc expression.

;;; The evaluator keeps track of an exception continuation,
;;; in addition to the regular continuation.  A throw
;;; expression is evaluated in a context where the regular
;;; continuation is the exception continuation.

;;; Abort evaluates an expression and returns the value as
;;; the answer of the computation.

;;; Break evaluates an expression, and like, abort, returns
;;; the value of that expression as the top level value.
;;; However, unlike abort, one may _resume_ from the break
;;; by invoking the top level command *resume*, passing it
;;; either nothing or a new value with which to resume the
;;; original computation.


;;; Once the interpreter implements letcc, all the other
;;; control constructs: exceptions, abort and break can be
;;; implemented using letcc.  Exercise: show  this. 
  
(require eopl/eopl)
(require "ast.ss")
(require "env-rec.ss")
(require "semantic-domains.ss")

(provide
   eval-ast
   *resume*)

(define *resume-init*
  (lambda args
    (*top-k* "Error: nothing to resume")))


(define *resume* *resume-init*)

;;; We assume the existence of the type answer?, which
;;; denotes the final answer of the entire computation, in
;;; this case, the evaluation of an expression or an error
;;; message.

;;; answer? : TYPE  = (or/c expressible-value? string?)

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
  (lambda (a env k ex-k)
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
              (eval-ast/k (if b then else-ast) env k ex-k)
              (*top-k*
                (format
                  "ifte test is not a boolean ~a" a))))
          ex-k)]
              
      [function (formals body)
        (k (closure formals body env))]
      
      [app (rator rands)
        (eval-ast/k rator env
          (lambda (p)
            (if (proc? p)
              (eval-asts/k rands env
                (lambda (args)
                  (apply-proc/k p args k ex-k)) ex-k)
              (*top-k*
                (format
                  "application rator is not a proc ~a"
                  a)))) ex-k)]
          
      [assume (binds body)
        (let ([ids  (map bind-id binds)]
              [asts (map bind-ast binds)])
          (eval-asts/k asts env
            (lambda (vals)
              (let ([new-env
                      (extended-env ids vals env)])
                (eval-ast/k body new-env k ex-k))) ex-k))]

      [recursive (fbinds body)
        (let*
          ([fids (map fbind-id fbinds)]
           [lformals (map fbind-formals fbinds)]
           [bodies (map fbind-body fbinds)]
           [new-env
             (extended-rec-env
               fids lformals bodies env)])
          (eval-ast/k body new-env k ex-k))]

      [abort (ans-ast)
        (eval-ast/k ans-ast env *top-k* ex-k)]
      
      [break (ans-ast)
        (eval-ast/k ans-ast env
          (lambda (v)
            (set! *resume*
              (match-lambda*
                ['() (k v)]
                [(list x) (k x)]
                [_ (*top-k* "Error: *resume* takes at most one argument")]))
            (*top-k* (format "breaking with value ~a" v))) ex-k)]
      
      [try (body exn-id handler)
        (eval-ast/k body env k
          (lambda (exn)
            (let ([new-env (extended-env (list exn-id) (list exn) env)])
              (eval-ast/k handler new-env k ex-k))))]

      [throw (exn-ast)
        (eval-ast/k exn-ast env ex-k ex-k)]
      
      [letcc (sym body)
        (let ([new-env (extended-env (list sym)
                         (list (continuation-proc k)) env)])
          (eval-ast/k body new-env k ex-k))]
      )))

;;; eval-asts/k :
;;; [(listof ast?) env? (K (listof expressible-value?)) (K)]
;;; -> answer?

(define eval-asts/k 
  (lambda (asts env k ex-k)
    (if (null? asts)
        (k '())
        (eval-ast/k (first asts) env
          (lambda (v)
            (eval-asts/k (rest asts) env
              (lambda (vals)
                (k (cons v vals))) ex-k)) ex-k))))

;;; apply-proc/k :
;;;  [proc? (listof expressible-value?) Keval?]
;;;    -> answer?

(define apply-proc/k
  (lambda (p args k ex-k)
    (cases proc p
      [prim-proc (prim sig)
        (apply-prim-proc/k prim sig args k)]
      [closure (formals body env)
        (apply-closure/k formals body env args k ex-k)]
      [continuation-proc (kont)  
        (apply-continuation kont args)] ; ignore k and ex-k !
      )))

;;; apply-prim-proc :
;;;  [procedure? (listof procedure?)
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
  (lambda (formals body env args k ex-k)
    (let ([new-env (extended-env formals args env)])
      (eval-ast/k body new-env k ex-k))))

(define apply-continuation
  (lambda (k args)
    (cond [(= (length args) 1)
           (*top-k* (apply k args))]
          [#t (*top-k* (format "incorrect number of arguments to continuation procedure ~a" k))])))

;;; eval-ast : [ast? env?] -> answer?
(define eval-ast
  (lambda (ast env)
    (eval-ast/k ast env *top-k* (lambda (v) "uncaught exception"))))


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

