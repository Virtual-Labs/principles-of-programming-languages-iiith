#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "quiz-1"]{Quiz}

@local-table-of-contents[]

@section{Question 1}

Consider the following inductive definition of nats.  Explain the
issues in trying to translate this definition into an
implementation of the nat inductive datatype.

@verbatim{

    ------
     0: N


    m: N, n : N
    -----------
     +(m,n) : N

}

@section{Question 2}

Consider the following implementation of z and s

@interaction[

(define z
  (lambda ()
    5))

(define s
   (lambda (n)
     (+ n n)))
]


Convince yourself that this is a plausible, even if unusual
representation of naturals by verifying the properties of
injectivity and disjointness of the constructors.  

What is the general formula for representing the natural number
@italic{n}?  

Write down the definition of the extractor @italic{predecessor}.
