#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "procedure-10"]{Procedure}

@local-table-of-contents[]

@section{The need for Encapsulation}

A variable is an identifier bound to a mutable location.  The
@emph{r-value} of a variable is the storable value in the location
referred to by the variable.  The @emph{l-value} of a variable is the
location denoted by the variable.

In the procedural model, variables store state, which may change with
time - hence the word @emph{variable}.  In languages without closures,
different procedures may share state through a global variable.  As an
example, consider the modeling of a one-dimensional point:

@racketblock[
	(define point 0)

	(define set
	 (lambda (v)
	  (set! point v)))

	(define get
	 (lambda ()
	  p))
]

The interface of point may be defined as:

@defproc[(get) number?]

@defproc[(set [num number?]) void?]

However, since the implementation of @racket[point] relies on the use
of a global variable, it is possible to change the value of point to
any value, even a non-numeric value, which breaks the invariant that
'get' is supposed to guarantee.

The problem here is that point is globally accessible and therefore
vulnerable to mutation by a @emph{third party}: another function, or
another @racket[set!] etc.  In other words, we have not sufficiently
@bold{encapsulated} the state variable @racket[point].

@section{Encapsulation via Closures}

@racketblock[
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
]

Note that the implementation ensures that the state variable
@racket[p] is accessible only to the methods @racket[get] and
@racket[set].  In other words, the only way to affect the state of the
variable @racket[p] from the outside is through the @racket[point]’s
interface, i.e., the @racket[get] and @racket[set] methods.
Furthermore, @racket[get] and @racket[set] are closures that share the
same lexical environment, and hence the same state variable
@racket[p].

@emph{In other words, closures provide a way to implement the
@bold{encapsulation of state}.}

So, in our implementation, @emph{an @bold{object} is a list of methods
that all share the same state variables.}
