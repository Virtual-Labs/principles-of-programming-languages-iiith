#lang racket/base

(require rackunit "lexical-ast.ss")

(provide ast-test)

(define-simple-check (check-ast? thing)
   (ast? thing))

(define ast-test
  (test-suite "test-for-ast.ss"

(check-ast? (number 5) "number test")
(check-ast? (boolean #t) "boolean test")

(check-ast? (prim-app '+ (list (number 5) (number 6))) "prim-app test")
(check-ast? (prim-app '+ (list (number 5))) "prim-app test")

(check-ast? (id-ref 'x) "id-ref-x test")

(check-ast? (assume
              (list
                (make-bind 'x (number 5))
                (make-bind 'y (number 6)))
              (prim-app '+ (list (id-ref 'x) (id-ref 'y))))
  "assume test")


(check-ast? (assume
              '()
              (prim-app '+ (list (id-ref 'x) (id-ref 'y))))
  "assume empty test")

(check-pred bind? (make-bind 'x (number 5)))
(check-pred bind? (make-bind 'y (prim-app '+ (list (number 5) (number 6)))))

(check-equal? (bind-id (make-bind 'y (number 6))) 'y)
(check-equal? (bind-id (make-bind 'x (prim-app '+ (list (number 5) (number 6))))) 'x)

(check-ast? (bind-ast (make-bind 'y (number 6))))
(check-ast? (bind-ast (make-bind 'y (prim-app '+ (list (number 5) (number 6))))))

(check-pred id? 'x "x-id")


(check-true (op-symbol? '<))
(check-true (op-symbol? '*))
(check-true (op-symbol? '+))
(check-true (op-symbol? '/))
     
  )
)
 
(require rackunit/text-ui)
(run-tests ast-test)








