#lang scribble/doc
@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "quiz-5"]{Quiz}

@local-table-of-contents[]

@itemlist[#:style 'ordered

@item{
@bold{Exercise (non-commutativity of composition)} Convince
yourself, with an example that the environment (e' . e) is
not the same as (e . e').  Hence environment composition is
not commutative.
}

@item{Implement the abstract data type for environments in
which environments are represented as a nested list of
@emph{ribs}, with each rib consisting of a pair of ids and
vals.  For example
@verbatim{

  (([x y z] [3 1 2]) ([x u y] [7 8 0]))}

is an environment consisting of two ribs.  It may be thought
of as being built by extending the environment (([x u y][7 8
0])) (say e1) with the ids (x y z) and denotable values (3 1
2).  e1 itself is built by extending the empty environment
() with ids (x u y) and denotable values (7 8 0).}

@item{Now consider an alternative representation of
environments as @emph{functions}.  Each environment is
represented by a function that takes an identifier and
returns a denotable value or an "identifier not bound"
error.  Implement the functions @racket{env?},
@racket{empty-env}, @racket{extend-env} and
@racket{lookup-env} so that they have the same 
signatures and and  behaviour as before.}
]

