#lang racket/base

(require rackunit "arithmetic-ast.ss")

(provide ast-test)

(define ast-test
  (test-suite "test-for-ast.ss"

    (check-equal? (ast? (number 5)) #t "number test")
    (check-true (ast? (prim-app '+ (list (number 5) (number 6)))) "prim-app test")
    (check-equal? (ast? #f) #t "number test") ;failure test
    (check-not-exn (lambda () (number #t)) "number-test:invalid argument to constructor number") ; failure test
    (check-not-exn (lambda () (prim-app '$ (number 4))) "prim-app-test:invalid arguments to constructor prim-app") ;failure test 
    
    (test-case
     "symbol-check"
     (let ([lst (list '* '+ '/)])
       (check = (length lst) 3)
       (for-each
        (lambda (sym)
          (check-true (op-symbol? sym)))
          lst)
        )
       )
     
  )
)
 
(require rackunit/text-ui)
(run-tests ast-test)


