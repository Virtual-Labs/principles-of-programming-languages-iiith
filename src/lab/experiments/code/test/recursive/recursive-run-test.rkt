#lang racket/base

(require rackunit "recursive-ast.ss" "recursive-env.ss" "recursive-semanticdomain.ss" "recursive-eval.ss" "recursive-parser.ss" "recursive-run.ss")

(provide recursive-run-test)

(define recursive-run-test
  (test-suite "test-for-recursive-experiment"

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
 (closure '(x y z)
   (app (id-ref '+)
     (list (id-ref 'x)
       (app (id-ref '*)
         (list (id-ref 'y) (id-ref 'z)))))
   *init-env*)
 "run: function-test")
))

(require rackunit/text-ui)                    
(run-tests recursive-run-test)
