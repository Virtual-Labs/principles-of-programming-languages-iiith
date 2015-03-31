#lang racket/base

(require rackunit "closure-ast.ss" "closure-env.ss" "closure-semanticdomain.ss" "closure-eval.ss" "closure-run.ss")

(provide closure-run-test)

(define closure-run-test
  (test-suite "test-for-closure-run.ss"

(check-equal?
  (run
      (assume (list (make-bind 'a (number 5))
                (make-bind 'b (number 6)))
        (app (id-ref '+)
          (list (id-ref 'a) (id-ref 'b)))))
  11 "run: assume-test")

  
(check-equal?
 (run
  (function                 ; (lambda (x y z) (+ x (* y z)))
   '(x y z)
   (app (id-ref '+)
        (list (id-ref 'x)
              (app (id-ref '*)
                   (list (id-ref 'y) (id-ref 'z)))))))
 7 "run: function-test")
  )
)
 
(require rackunit/text-ui)
(run-tests closure-run-test)


