#lang scheme

;;; ==========================================
;;; Abstract Syntax for the RECURSION language
;;; ==========================================



;;; <ast> ::= <num-ast> |
;;;           <bool-ast> |
;;;           <id-ref-ast> |
;;;           <assume-ast> |
;;;           <ifte-ast>   |  
;;;           <recfun-ast> |
;;;           <function-ast> |
;;;           <app-ast> 


;;; <num-ast>        ::= (number <number>)
;;; <bool-ast>       ::= (boolean <boolean>)
;;; <function-ast>   ::= (function (<id> ... ) <ast>)
;;; <app-ast>        ::= (app  <ast>  <ast> ...)
;;; <assume-ast>     ::= (assume (<bind> ...) <ast>)
;;; <bind-ast>       ::= (<id> <ast>)
;;; <id-ref-ast>     ::= (id-ref <id>)
;;; <id>             ::= <symbol>
;;; <ifte-ast>       ::= (ifte <ast> <ast> <ast>)
;;; <recfun-ast>     ::= (recursive (<fbind> ...) <ast>)
;;; <fbind>          ::= (<id> (<id> ...) <ast>)


;;; (recursive ([even? (n) (if (0? n) #t (odd? (sub1 n)))]
;;;             [odd?  (n) (if (0? n) #f (even? (sub1 n)))])
;;;    (even? 5))


(require eopl/eopl)

(provide
  ast
  ast?
  number
  id-ref
  function
  app
  assume
  make-bind
  bind-id
  bind-ast
  make-fbind
  fbind-id
  fbind-formals
  fbind-body
  ifte
  recursive)

(define-datatype ast ast?
  [number (datum number?)]
  [ifte (test ast?) (then ast?) (else-ast ast?)]
  [function
   (formals (list-of id?))
   (body ast?)]
  [recursive (fbinds (list-of fbind?)) (body ast?)]
  [app (rator ast?) (rands (list-of ast?))]
  [id-ref (sym id?)]
  [assume (binds  (list-of bind?)) (body ast?)])

(define-datatype bind bind?
  [make-bind (b-id id?) (b-ast ast?)])

;;; bind-id : bind? -> id?
(define bind-id
  (lambda (b)
    (cases bind b
      [make-bind (b-id b-ast) b-id])))

;;; bind-ast : bind? -> ast?
(define bind-ast
  (lambda (b)
    (cases bind b
      [make-bind (b-id b-ast) b-ast])))


(define-datatype fbind fbind?
  [make-fbind (fb-id id?)
              (fb-formals (list-of id?))
              (fb-body ast?)])

;;; fbind-id : fbind? -> id?
(define fbind-id
  (lambda (b)
    (cases fbind b
      [make-fbind (fb-id fb-formals fb-body) fb-id])))

;;; fbind-formals : fbind? -> (list-of id?)
(define fbind-formals
  (lambda (b)
    (cases fbind b
      [make-fbind (fb-id fb-formals fb-body) fb-formals])))

;;; fbind-body : fbind? -> ast?
(define fbind-body
  (lambda (b)
    (cases fbind b
      [make-fbind (fb-id fb-formals fb-body) fb-body])))


(define id? symbol?)

