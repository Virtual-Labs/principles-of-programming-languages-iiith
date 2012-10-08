#lang racket/base

(require rackunit "recursive-ast.ss")

(provide ast-test)

(define-simple-check
  (check-ast? thing)
  (ast? thing))

(define ast-test
  (test-suite "test-for-abstract-syntax"

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
))

(require rackunit/text-ui)                    
(run-tests ast-test)







