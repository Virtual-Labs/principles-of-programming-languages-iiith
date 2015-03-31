#lang scheme

;;; =========================================
;;; Abstract Syntax for the language LEXICAL
;;; =========================================



;;; <ast> ::= <num-ast> | <bool-ast> |
;;;           <prim-app-ast> |
;;;           <assume-ast>
;;;           <id-ref-ast>

;;; <num-ast>  ::= (number <number>)
;;; <bool-ast> ::= (boolean <boolean>)
;;; <prim-app-ast> ::= (prim-app <op> <ast> ...)
;;; <assume-ast>   ::=(assume
;;;                    ((<id> <ast>) ...) <ast>)
;;; <id-ref-ast>   ::= (id-ref <id>)


(require eopl/eopl)

(provide
  ast
  ast?
  bind?
  number
  id-ref
  id?
  prim-app
  assume
  *op-symbols*
  op-symbol?
  make-bind
  bind-id
  bind-ast)

(define-datatype ast ast?
  [number (datum number?)]
  [prim-app (op op-symbol?) (rands (list-of ast?))]
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

(define *op-symbols*
  '(+ - * /))

;;; op-symbol? : symbol? -> bool
(define op-symbol?
  (lambda (x)
    (if (memq x *op-symbols*)
      #t
      #f)))



