#lang racket

(require eopl/eopl)

(provide make-obj
	 incr-x
	 send)
;;; ============================================
;;; A simple implementation of Objects in Scheme
;;; ============================================

;;; Objects are implemented as closures that hold fields.


;;; Concrete syntax for objects:

;;; (<obj> <field>) returns the value of <field> if it
;;; exists; an error otherwise.  <obj> is a scheme expression
;;; that  evaluates to an object. <field> is an
;;; expression that  evaluates to a symbol.

;;; (<obj> <field> <val>) sets the value of <field> to
;;; <value>.  <val> evaluates to any scheme value. 


;;; make-obj : [] -> obj?

(define make-obj
  (lambda () 
    (let ([table (make-hash)])
      (lambda (msg . args) ; args is either empty or a
                           ; singleton list containing a
                           ; value.
        (if (null? args)
          ;; it's a get
            (hash-ref
             table msg
             (lambda ()
               (error "obj: do not know method ~a"  msg)))
            ;; it's a set
          (hash-set! table msg (first args)))))))

;;; Methods are functions that operate on objects.  By
;;; convention, the object is the first formal parameter of
;;; the method and is named 'this' or 'self'. 

;;; incr-x : [obj? number?] -> void?
(define incr-x
  (lambda (this v)
    (this 'x (+ v (this 'x)))))

;;; (c1 'incr-x incr-x)

;;; ((c1 'incr-x) c1 v)


;;; Send sets up a protocol for invoking the method name on
;;; the object.  It looks up the method corresponding to the
;;; method name, and then applies that to the list
;;; consisting of the object and the rest of the arguments.

(define send
  (lambda (obj method-name . args)
    (apply (obj method-name) (cons obj args))))

;;; (send c1 'incr-x v)




