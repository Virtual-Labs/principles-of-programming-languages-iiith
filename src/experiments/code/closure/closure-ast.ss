#lang scheme

;;; =========================================
;;; Abstract Syntax for the language FUNCTION
;;; =========================================



;;; <ast> ::= <num-ast> | <bool-ast> |
;;;           <id-ref-ast> |
;;;           <assume-ast> |
;;;           <function-ast> |
;;;           <app-ast> 


;;; <num-ast>  ::= (number <number>)
;;; <bool-ast> ::= (boolean <boolean>)
;;; <function-ast> ::= (function (<id> ... ) <ast>)
;;; <app-ast>      ::= (app  <ast>  <ast> ...)
;;; <assume-ast>   ::=(assume
;;;                    ((<id> <ast>) ...) <ast>)
;;; <id-ref-ast>   ::= (id-ref <id>)
;;; <id>           ::= <symbol>


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
  bind-ast)

(define-datatype ast ast?
  [number (datum number?)]
  [function
   (formals (list-of id?))
   (body ast?)]
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

(define id? symbol?)

