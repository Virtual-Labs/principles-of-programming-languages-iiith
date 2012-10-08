#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "programming-10"]{Programming}

@local-table-of-contents[]

@section{Objects}

As discussed in the earlier sections, objects are implemented as closures that hold fields:

@bold{Concrete Syntax for objects}:

@itemlist[#:style 'ordered 
	@item{@racket[(<obj> <field>)] returns the value of <field> if it exists; an error otherwise.}
	@item{<obj> is a scheme expression that evaluates to an object.}
	@item{<field> is an expression that evaluates to a symbol.}
	@item{@racket[(<obj> <field> <val>)] sets the value of <field> to <value>.}
	@item{<val> evaluates to any scheme value.}
]

The following is the implementation of @racket[make-obj], which basically returns an object:

@defproc[(make-obj) obj?]

@racketblock[
	(define make-obj
	 (lambda ()
	  (let ([table (make-hash)])
	   (lambda (msg . args)
	    (if (null? args)
	     (hash-ref
	      table msg
	      (lambda ()
	       (error "obj: do not know method ~a"  msg)))
	     (hash-set! table msg (first args)))))))
]

where @racket[args] is either empty or a singleton list containing a value.

@section{Methods}

Methods are functions that operate on objects.  By convention, the
object is the first formal parameter of the method and is named
@racket[this] or @racket[self].

Lets consider the following example of @racket[incr-x], which
increments the value of an object by some amount:

@defproc[(incr-x [o obj?] [num number?]) void?]

@racketblock[
	(define incr-x
	 (lambda (this v)
	  (this 'x (+ v (this 'x)))))
]

@racket[(c1 'incr-x incr-x)] - @racket[c1] is the instance of the
object.

@racket[((c1 'incr-x) c1 v)] - Incrementing the value of @racket[c1]
by @racket[v], using the inherent class method @racket[incr-x].

@section{send}

@racket[send] sets up a protocol for invoking the method name on the
object.  It looks up the method corresponding to the method name, and
then applies that to the list consisting of the object and the rest of
the arguments.

@racketblock[
	(define send
	 (lambda (obj method-name . args)
	  (apply (obj method-name) (cons obj args))))
	(send c1 'incr-x v)
]
