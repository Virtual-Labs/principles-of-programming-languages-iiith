#lang scribble/doc

@(require scribble/manual
		scribble/bnf
		scribblings/scribble/utils
		(for-label scriblib/figure))

@title[#:tag "procedure-2"]{Procedure}

@bold{@emph{Recursive programs on inductive-datatypes:}}

@emph{Example:} Factorial of a natural number

@emph{Recipe for the design:}
@itemlist[#:style 'ordered
@item{Check for the base case(s) first.

	n : nat?

	if n is 0, then n! = 1

Do note that these base cases turn out to be the 'end-condition' for your recursive program, i.e. the point(s) where the recursive program stops calling itself and terminates.
}
@item{Define your problem recursively, and call the function recursively

	else n! = n * (n-1)!
}
]

@bold{@emph{Code:}}

@emph{Purpose:} Write a recursive program that computes the factorial of a natural

@emph{Signature:} 
@defproc[(! [num nat?]) nat?]

@emph{Implementation:}


@racketblock[
(define !
 (lambda (n)   ;; n is a natural number
  (cond
   [(zero? n) 1] @; base case
   [else (* n (! (- n 1)))] @; recursive definition
   )))

(! 3)
]

Kindly observe the growing context, around each call to @racket[!] in this case:

@racket[(! 3)]

= @racket[(* 3 (! 2))] 

= @racket[(* 3 (* 2 (! 1)))]
	
= @racket[(* 3 (* 2 (* 1 (! 0))))]

This kind of growing context may result in a stack-overflow problem.
Also, the above logic fails for cases like @racket[(! -1)], where it results in an infinite loop.


@emph{Factorial with accumulator:}

In order to overcome the above stated issues, we shall look into accumulators.

@emph{Accumulator} is the value in which we store the result so far. 

@racketblock[
	(define !/a
	 (lambda (n a)
	  (cond
	   [(zero? n) a]
	   [else (!/a (sub1 n) (* n a))])))

	(define !
	 (lambda (n)
	  (!/a n 1)))

(! 3)
]

Now, observe the growing context, around each call to @racket[!/a] in this case:

@racket[(! 3)]

= @racket[(!/a 3 1)]

= @racket[(!/a 2 (* 3 1))]

= @racket[(!/a 1 (* 2 3))]

= @racket[(!/a 0 (* 1 6))]


Notice that the context doesn't grow. This is because the recursive call to @racket[!/a] is in a tail position => @emph{Tail Recursion}

@emph{An expression e is in a tail position w.r.t an enclosing expression e' if the evaluation of e is the last thing that happens in the evaluation of e'}

@emph{Reasoning:}

@itemlist[
	@item{In the first case, you:

	@itemlist[#:style 'ordered
	@item{get some answer i.e. @racket[(! (- n 1))]
	}
	@item{do some post-processing @racket[(* n (! (- n 1)))] [multiplication being the post-processing part]
	}
	]
	}
@item{In the second case: once you get the answer, it is final
}
]


