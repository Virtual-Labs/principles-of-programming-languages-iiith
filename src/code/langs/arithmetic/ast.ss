;;; POPL Lec 10 of 2010-09-17
;;; ==========================================================
;;; Abstract Syntax Specification of a language for arithmetic
;;; ==========================================================
;;; ast ::= num-ast | bool-ast | prim-app-ast


#lang racket

(require eopl/eopl)

(provide
  ast
  ast?
  number
  boolean
  *op-symbols*
  op-symbol?
  prim-app)

(define *op-symbols*
  '(+ - * /
    < <= eq? 0?))

;;; op-symbol? : symbol? -> bool
(define op-symbol?
  (lambda (x)
    (if (memq x *op-symbols*)
      #t
      #f)))

(define-datatype ast ast?
  [number (datum number?)]
  [boolean (datum boolean?)]
  [prim-app (op op-symbol?) (rands (list-of ast?))])


;;; unit Testing
;;; ============

;;; Racket's unit testing framework
(require rackunit)

;;; You should see nothing untoward when you load ast.ss
;;; using a require or load.  Try changing the ast? to
;;; number? if you want to see an error reported by the
;;; rackunit unit testing framework

(check-equal? (ast? (number 5)) #t "number test")
(check-pred ast? (boolean #t) "boolean test")
(check-true (ast? (prim-app '+ (list (number 5) (number 6)))) "prim-app test")

(define-simple-check (check-ast? thing)
   (ast? thing))

(check-ast? (number 8))
;;; this check, when run will fail.
;;; (check-equal? (ast? 5) #t "number test")

;;; Failure tests

(check-exn exn? (lambda () (number #t)) "number-test:invalid argument to constructor number")
(check-exn exn? (lambda () (boolean 'x)) "boolean-test:invalid argument to constructor boolean")
(check-exn exn? (lambda () (prim-app '$ (number 4))) "prim-app-test:invalid arguments to constructor prim-app")


;;; the prim-app ast builder  doesn't do type checking
(check-equal? (ast? (prim-app '+ (list (number 5) (boolean #t)))) #t "prim-app test2")

(check-equal?
  (cases ast (number 5)
         ;; different cases of ast
         [number (datum) datum]
         [else 'ignore]
         ) ; returned
  5        ; expected
  "number cases test")

(check-equal?
  (cases ast (boolean #f)
         [boolean (datum) datum]
         [else  'ignore]
         ) ; returned
  #f       ; expected
  "boolean cases test")

(let ([ans (cases ast (prim-app '+ (list (number 5) (boolean #t)))
             [prim-app (op rands) (list op rands)]
             [else 'ignore])])
  (check-equal?
   ans
   (list '+ (list (number 5) (boolean #t)))
   "prim-app cases test"))
           
(check-true (op-symbol? '<))
(check-true (op-symbol? '*))
(check-true (op-symbol? '+))
(check-true (op-symbol? '/))
