;;; ===============================
;;; Motivating the need for Objects
;;; ===============================

;;; (c) Venkatesh Choppella <choppell@gmail.com>
;;; released under GPL

;;; A variable is an identifier bound to a mutable location.
;;; The (r)-value of a variable is the storable value in the
;;; location referred to by the variable.  The l-value of a
;;; variable is the location denoted by the variable.

;;; In the procedural model, variables store state, which
;;; may change with time (hence the word 'variable').  In
;;; languages without closures, Different procedures may
;;; *share* state through a global variable.  As an example,
;;; consider the modeling of a one-dimensional point:

(define point 0)

(define set
  (lambda (v)
    (set! point v)))

(define get
  (lambda ()
    p))

;;; The interface of point may be defined as

;;; get : ()      -> number?
;;; set : number? -> void?

;;; However, since the implementation of point relies on the
;;; use of a global variable, it is possible to change the
;;; value of point to any value, even a non-numerical value,
;;; which breaks the invariant that get is supposed to
;;; guarantee.  


;;; The problem here is that point is globally accessible
;;; and therefore vulnerable to mutation by a "third party":
;;; another function, or another set! etc.  In other words,
;;; we have not suffiently *encapsulated* the state variable
;;; point.


;;; Encapsulation via closures
;;; ==========================

(define make-point
  (lambda (n)
    (let ([p n])
      (let ([get (lambda ()
                   p)]
            [set (lambda (v)
                   (set! p v))])
        (list get set)))))

(define p1 (make-point 5))

(define p1.get (first p1))
(define p1.set (second p1))

(require rackunit)

(check-equal? (p1.get) 5 "p1.get")
(check-equal? (p1.set 4) (void) "p1.set")


;;; Note that the implementation ensures that the state
;;; variable p is accessible *only* to the methods get and
;;; set.  In other words, the *only* way to affect the state
;;; of the variable p from the outside is through the
;;; point's interface, i.e., the get and set methods.
;;; Furthermore, get and set are closures that share the
;;; same lexical environment, and hence the same state
;;; variable p.

;;; In other words, closures provide a way to implement the
;;; encapsulation of state.


;;; So, in our implementation, an object is a list of
;;; methods that all share the same state variables.  One
;;; could argue that this is a rather awkward structure.  In
;;; the next class, we shall see how to represent objects
;;; (not just their methods) as functions.
