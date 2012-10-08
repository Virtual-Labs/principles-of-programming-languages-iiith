#lang racket/base

(require rackunit "closure-ast.ss")

(provide closure-ast-test)

(define-simple-check (check-ast? thing)
   (ast? thing))

(define closure-ast-test
  (test-suite "test-for-closure-ast.ss"

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
  )
)
 
(require rackunit/text-ui)
(run-tests closure-ast-test)


