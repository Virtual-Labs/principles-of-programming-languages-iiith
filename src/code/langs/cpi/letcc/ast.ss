#lang scheme

;;; ======================================
;;; Abstract Syntax for the LETCC language
;;; ======================================

;;; <ast> ::= <num-ast> |
;;;           <bool-ast> |
;;;           <id-ref-ast> |
;;;           <assume-ast> |
;;;           <ifte-ast>   |  
;;;           <recfun-ast> |
;;;           <function-ast> |
;;;           <app-ast>      |
;;;           <abort-ast>    |
;;;           <try-ast>      |
;;;           <throw-ast>    |
;;;           <letcc-ast>

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
;;; <abort-ast>      ::= (abort <ast>)
;;; <break-ast>      ::= (abort <ast>)
;;; <try-ast>        ::= (try <ast> <id> <ast>)
;;; <throw-ast>      ::= (throw <ast>)
;;; <letcc-ast>      ::= (letcc <id> <ast>)

(require eopl/eopl)

(provide
  ast
  ast?
  number
  boolean
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
  recursive
  abort
  break
  try
  throw
  letcc)

(define-datatype ast ast?
  [number (datum number?)]
  [boolean (datum boolean?)]
  [ifte (test ast?) (then ast?) (else-ast ast?)]
  [function
   (formals (list-of id?))
   (body ast?)]
  [recursive (fbinds (list-of fbind?)) (body ast?)]
  [app (rator ast?) (rands (list-of ast?))]
  [id-ref (sym id?)]
  [assume (binds  (list-of bind?)) (body ast?)]
  [abort (ans-ast ast?)]
  [break (ans-ast ast?)]
  [try (body ast?) (exn-id id?) (handler ast?)]
  [throw (exn-ast ast?)]
  [letcc (sym id?) (body ast?)]
  )

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

;;; unit Testing
;;; ============

;;; Racket's unit testing framework
(require rackunit)


(define-simple-check
  (check-ast? thing)
  (ast? thing))

(check-ast? (number 5) "number-5 test")
(check-ast? (boolean #t) "boolean-#t test")
(check-ast? (id-ref 'x) "id-ref-x test")
(check-ast? (function
              '(x y z)
              (app (id-ref '+)
                (list (id-ref 'x)
                  (app (id-ref '*)
                    (list (id-ref 'y) (id-ref 'z)))))) "function-test")


(check-ast?
  (app (id-ref '+)
    (list (number 5) (number 6))) "app test")


(check-ast?
  (assume (list (make-bind 'x (number 5))
            (make-bind 'y (number 6)))
    (app (id-ref '+)
      (list (id-ref 'x) (id-ref 'y)))) "assume-test")



;;; A feasible concrete syntax for recursive:
;;; (recursive ([even? (n) (if (0? n) #t (odd? (- n 1)))]
;;;             [odd?  (n) (if (0? n) #f (even? (- n 1)))])
;;;    (even? 5))

(check-ast?
  (recursive
   (list
    (make-fbind 'even?
                '(n)
                (ifte (app (id-ref '0?) (list (id-ref 'n)))
                      (boolean #t)
                      (app (id-ref 'odd?)
                        (list (app (id-ref '-) (list (id-ref 'n) (number 1)))))))

    (make-fbind 'odd?
                '(n)
                (ifte (app (id-ref '0?) (list (id-ref 'n)))
                      (boolean #f)
                      (app (id-ref 'even?)
                        (list (app (id-ref '-) (list (id-ref 'n) (number 1))))))))
   
   (app (id-ref 'even?) (list (number 3))))
   "recursive-ast test")
















