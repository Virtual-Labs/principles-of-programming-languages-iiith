#lang racket

(require eopl/eopl)
(require rackunit)
(require rackunit/text-ui)
(require "../arithmetic.ss")

(provide test-arithmetic)

(define test-arithmetic
(lambda ()
	(run-tests
	(test-suite "arithmetic-test"
	(test-case "ast-test"
	(check-equal? (ast? (boolean #t)) #t)
	(check-equal? (ast? (number 5)) #t)
	(check-true (ast? (prim-app '+ (list (number 5) (number 6)))))
	(check-exn exn? (lambda () (number #t)))
	(check-exn exn? (lambda () (boolean 'x)))
	(check-exn exn? (lambda () (prim-app '$ (number 4))))
	(check-equal?
	  (cases ast (number 5)
         [number (datum) datum]
         [else 'ignore]
         )5)
	(check-equal?
	  (cases ast (boolean #f)
         [boolean (datum) datum]
         [else  'ignore]
         ) #f)
	 (check-equal?
		(cases ast (prim-app '+ (list (number 5) (boolean #t)))
	             [prim-app (op rands) (list op rands)]
        	     [else 'ignore])
		   (list '+ (list (number 5) (boolean #t))))
	)
	(test-case "parse-test"
	(check-equal? (number 5)   (parse 5))
	(check-equal? (boolean #t) (parse #t))
	(check-equal? (prim-app '+ (list (number 3)))
              (parse '(+ 3)))
	(check-exn exn? (lambda () (parse 'x)))
	(check-exn exn? (lambda () (parse '())))
	)
	(test-case "op-test"
	(check-true (op-symbol? '<))
	(check-true (op-symbol? '*))
	(check-true (op-symbol? '+))
	(check-true (op-symbol? '/))
	(check-true (op-symbol? '<=))
	(check-true (op-symbol? 'eq?))
	(check-true (op-symbol? '0?))
	)
	(test-case "eval-test"
	(check-equal? (eval-ast (number 5)) 5)
	(check-equal? (eval-ast (boolean #t)) #t)
	(check-equal? (eval-ast (prim-app '+ (list (number 5) (number 7)))) 12)
	(check-equal? (eval-ast (prim-app 'eq? (list (number 5) (number 5)))) #t)
	(check-equal? (eval-ast (prim-app 'eq? (list (number 5) (number 7)))) #f)
	(check-equal? (eval-ast (prim-app '< (list (number 5) (number 7)))) #t)
	(check-equal? (eval-ast (prim-app '< (list (number 8) (number 7)))) #f)
	(check-equal? (eval-ast (prim-app '<= (list (number 7) (number 7)))) #t)
	(check-equal? (eval-ast (prim-app '<= (list (number 9) (number 7)))) #f)
	(check-equal? (eval-ast (prim-app '0? (list (number 0)))) #t)
	(check-equal? (eval-ast (prim-app '0? (list (number 5)))) #f)
	(check-exn exn? (lambda () (eval-ast (prim-app '+ (list (number 5) (boolean #t))))) "Incorrect types")
	(check-exn exn? (lambda () (eval-ast (prim-app '/ (list (number 5) (number 0))))) "Divide by zero")
	)
	(test-case "run-test"
	(check-equal? 5 (run 5))
	(check-equal? #t (run #t))
	(check-equal? 7 (run '(+ 3 4)))
	(check-equal? #f (run '(0? 7)))
	(check-equal? 14 (run '(* (+ 3 4) 2)))
	(check-exn  exn?
            (lambda () (run '(+ *))))
	(check-exn  exn?
            (lambda () (run '(0? #t))))
	)
) 'normal)))
