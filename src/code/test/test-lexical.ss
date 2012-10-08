#lang racket

(require eopl/eopl)
(require rackunit)
(require rackunit/text-ui)
(require "../lexical.ss")

(provide test-lexical)

(define test-lexical
(lambda ()
	(define e1
	  (extended-env '(x y z) '(1 2 3) (empty-env)))
	(define e2
	  (extended-env '(w x) '(5 6) e1))
	(run-tests
	(test-suite "lexical-test"
	(test-case "ast-test"
	(check-pred ast? (number 5))
	(check-pred ast? (boolean #t))
	(check-pred ast? (prim-app '+ (list (number 5) (number 6))))
	(check-pred ast? (prim-app '+ (list (number 5))))
	(check-pred ast? (id-ref 'x))
	(check-pred ast? (assume
		      (list
		        (make-bind 'x (number 5))
		        (make-bind 'y (number 6)))
		      (prim-app '+ (list (id-ref 'x) (id-ref 'y)))))
	(check-pred ast? (assume
		      '()
		      (prim-app '+ (list (id-ref 'x) (id-ref 'y)))))
	(check-pred bind? (make-bind 'x (number 5)))
	(check-pred bind? (make-bind 'y (prim-app '+ (list (number 5) (number 6)))))
	(check-equal? (bind-id (make-bind 'y (number 6))) 'y)
	(check-equal? (bind-id (make-bind 'x (prim-app '+ (list (number 5) (number 6))))) 'x)
	(check-pred ast? (bind-ast (make-bind 'y (number 6))))
	(check-pred ast? (bind-ast (make-bind 'y (prim-app '+ (list (number 5) (number 6))))))
	(check-pred id? 'x)
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

	(check-equal? 11 (eval-ast (prim-app '+ (list (id-ref 'x) (id-ref 'w))) e2)) 
	(check-equal? 8 (eval-ast (prim-app '+ (list (id-ref 'x) (id-ref 'y))) e2)) 
	(check-equal? (eval-ast (assume (list (make-bind 'x (number 8))
		                  (make-bind 'y (number 7)))
		            (prim-app '+ (list (id-ref 'x) (id-ref 'y)))) e2) 15)
	(check-equal? (eval-ast (assume (list (make-bind 'x (number 8))
		                  (make-bind 'y (number 7)))
		            (prim-app '+ (list (id-ref 'x) (id-ref 'w)))) e2) 13)
	(check-equal?  (eval-ast (id-ref'w) e2) 5) 
	)
) 'normal)))
