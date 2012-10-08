#lang scheme

;;; ==========================================
;;; Evaluator for the EXPLICIT STORE language
;;; ==========================================
  
(provide
   eval-ast
   eval-ast/new-store
   )


(require eopl/eopl)
(require "ast.ss")
(require "semantic-domains.ss")

;;; (require (prefix-in store: "store-list.ss")) ; BROKEN,
;;; perhaps due to a bug in eopl?

;;; Racket manual says use prefix-in, but that doesn't work
;;; when eopl is already imported, like above.  When
;;; 'prefix-in' is replaced by 'prefix', everything works.
;;; Strange, since this behaviour isn't documented
;;; anywhere.

(require (prefix store: "store-list.ss"))

;;; answer? = store? expressible-value?

;;; eval-ast : [ast? env? store?]-> answer?
;;; eval-ast :  throws error


(define eval-ast
  (lambda (a env store)
    (cases ast a
      [number (datum) (values store datum)]
      [boolean (datum) (values store datum)]
      
      [id-ref (sym) (values store (lookup-env env sym))]
      
      [ifte (test then else-ast)
        (let-values ([(s-test b) (eval-ast test env store)])
          (if (boolean? b)
            (eval-ast (if b then else-ast) env s-test)
            (error 'eval-ast "ifte test is not a boolean ~a" a)))]
      
      [function (formals body)
        (values store (closure formals body env))]
      
      [app (rator rands)
        (let*-values ([(store p)
                       (eval-ast rator env store)]
                      [(store args)
                       (eval-asts rands env store)])
          (if (proc? p)
            (apply-proc p args store)
            (error 'eval-ast "application rator is not a proc ~a" a)))]

      [assume (binds body)
        (let*
          ([ids  (map bind-id binds)]
           [asts (map bind-ast binds)])
          (let-values ([(store vals) (eval-asts asts env store)])
            (let ([new-env (extended-env ids vals env)])
              (eval-ast body new-env store))))]

      [recursive (fbinds body)
        (let*
          ([fids (map fbind-id fbinds)]
           [lformals (map fbind-formals fbinds)]
           [bodies (map fbind-body fbinds)]
           [new-env
             (extended-rec-env
               fids lformals bodies env)])
          (eval-ast body new-env store))]
      
      [deref (a)
        (let-values ([(store r) (eval-ast a env store)])
          (if (store:ref? r)
            (let ([v (store:deref store r)])
              (values store v))
            (error 'eval-ast "not a reference ~a" r)))]

      [new-ref (a)
        (let-values ([(store v) (eval-ast a env store)])
          (match-let ([(list store r) (store:new-ref store v)])
            (values store r)))]

      [setref (a v)
        (let*-values ([(store r) (eval-ast a env store)]
                      [(store v) (eval-ast v env store)])
          (if (store:ref? r)
            (values (store:setref store r v) (void))
            (error 'eval-ast "not a reference ~a" r)))])))

;;; eval-asts : [(listof ast?) env? store?] -> [store? (listof expressible-value?)]

(define eval-asts
  (lambda (asts env store)
    (letrec ([loop
              (lambda (asts vals store)
                (cond
                  [(null? asts) (values store (reverse vals))]
                  [#t (let-values ([(store val)
                                    (eval-ast (first asts) env store)])
                        (loop (rest asts) (cons val vals) store))]))])
      (loop asts '() store))))
      

;;; apply-proc :
;;;  [proc? (list-of expressible-value?) store?]
;;;    -> answer?

(define apply-proc
  (lambda (p args store)
    (cases proc p
      [prim-proc (prim sig)
        (values store (apply-prim-proc prim sig args))]
      [closure (formals body env)
        (apply-closure formals body env args store)])))


;;; apply-prim-proc :
;;;  [procedure? (listof procedure?)
;;;     (listof expressible-value?)] -> expressible-value?
;;;
;;; apply-prim-proc : throws error when number or type of
;;;     args do not match the signature of prim-proc

(define apply-prim-proc
  (lambda (prim sig args)
    (let* ([args-sig (rest sig)])
      (cond
       [(and
          (= (length args-sig) (length args))
          (andmap match-arg-type args-sig args))
        (apply prim  args)]
       [#t (error 'apply-prim-proc
             "incorrect number or type of arguments to ~a"
             prim)]))))

;;; match-arg-type : [procedure? any/c] -> boolean?
(define match-arg-type
  (lambda (arg-type val)
    (arg-type val)))

;;; apply-closure : [closure? (listof expressible-value?)]
;;;                  -> answer?

(define apply-closure
  (lambda (formals body env args store)
    (let ([new-env (extended-env formals args env)])
      (eval-ast body new-env store))))


;;; eval-ast/new-store : [ast? env?] -> answer?

(define eval-ast/new-store
  (lambda (ast env)
    (eval-ast ast env (store:new-store))))

;;; Unit testing
;;; ============

(require rackunit)

(define-simple-check
  (check-eval-ast? ast env store expected label)
  (let-values ([(store val) (eval-ast ast env store)])
    (check-equal? val expected label)))


(define e1
  (extended-env '(x y z) '(1 2 3) (empty-env)))

(let ([n5 (number 5)]
      [n7 (number 7)]
      [bt (boolean #t)]
      [id1 (id-ref 'x)]
      [id2 (id-ref 'y)]
      [id3 (id-ref 'z)]
      [store (store:new-store)])
  (check-eval-ast? n5  e1  store 5 "eval-ast: n5 test")
  (check-eval-ast? bt  e1  store #t "eval-ast: bt test")
  (check-eval-ast? id1 e1  store 1 "eval-ast: id1 test")
  (check-eval-ast? id2 e1  store 2 "eval-ast: y test"))

(check-eval-ast?
  (assume (list (make-bind 'x (new-ref (number 4))))
    (deref (id-ref 'x)))
  e1
  (store:new-store)
  4
  "eval-ast: new-ref1")

(check-eval-ast?
  (assume (list (make-bind 'x (new-ref (number 4))))
    (assume (list (make-bind 'y (deref (id-ref 'x))))
      (id-ref 'y)))
  e1
  (store:new-store)
  4
  "eval-ast: new-ref2")

(check-eval-ast?
  (assume (list (make-bind 'x (new-ref (number 4))))
    (assume (list (make-bind 'ignore (setref (id-ref 'x) (number 7))))
      (id-ref 'x)))
  e1
  (store:new-store)
  0
  "eval-ast: new-ref3")

(check-eval-ast?
  (assume (list (make-bind 'x (new-ref (number 4))))
    (assume (list (make-bind 'ignore (setref (id-ref 'x) (number 7))))
      (deref (id-ref 'x))))
  e1
  (store:new-store)
  7
  "eval-ast: new-ref4")

(define-simple-check
  (check-eval-ast/new-store? ast env  expected label)
  (let-values ([(store val) (eval-ast ast env (store:new-store))])
    (check-equal? val expected label)))


(check-eval-ast/new-store?
  (assume (list (make-bind 'x (new-ref (number 4))))
    (deref (id-ref 'x)))
  e1
  4
  "eval-ast: new-ref-new-store1")

(check-eval-ast/new-store?
  (assume (list (make-bind 'x (new-ref (number 4))))
    (assume (list (make-bind 'y (deref (id-ref 'x))))
      (id-ref 'y)))
  e1
  4
  "eval-ast: new-ref-new-store2")


(check-eval-ast/new-store?
  (assume (list (make-bind 'x (new-ref (number 4))))
    (assume (list (make-bind 'ignore (setref (id-ref 'x) (number 7))))
      (id-ref 'x)))
  e1
  0
  "eval-ast: new-ref-new-store3")

(check-eval-ast/new-store?
  (assume (list (make-bind 'x (new-ref (number 4))))
    (assume (list (make-bind 'ignore (setref (id-ref 'x) (number 7))))
      (deref (id-ref 'x))))
  e1
  7
  "eval-ast: new-ref-new-store4")

;;; trying to deref a non-reference 
(check-exn exn?
  (lambda ()
    (eval-ast/new-store
      (assume (list (make-bind 'x (new-ref (number 4))))
        (deref (number 7)))))
  "eval-ast/new-store: error-deref")


;;; trying to setref a  non-reference 
(check-exn exn?
  (lambda ()
    (eval-ast/new-store
      (assume (list (make-bind 'x (new-ref (number 4))))
        (setref (number 7) (boolean #f)))))
  "eval-ast/new-store: error-setref")


;;; creating a circular reference.
 (check-eval-ast/new-store?
  (assume (list (make-bind 'x (new-ref (boolean #f))))
    (assume (list (make-bind 'ignore (setref (id-ref 'x) (id-ref 'x))))
      (eq? (id-ref 'x) (deref (id-ref 'x)))))
  e1
 #t
 "eval-ast/new-store: circular-ref"
 )
