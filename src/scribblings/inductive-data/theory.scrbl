#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "theory-1"]{Theory}

@local-table-of-contents[]

Informally, an inductive datatype is a datatype whose
elements can be described as being built one step at a time,
starting from one or more base cases.

Mathematically speaking, an @emph{inductive set} is the
smallest closed set built from a set of @emph{constructors}.
We shall explain this idea further in this section.

@bold{@emph{Why study inductive types?}}  Inductive
datatypes are everywhere in computing and programming.
Many data structure like numbers, lists, trees and, programs
and even mathematical proofs are examples of inductive
datatypes.  Therefore it is necessary to understand how to
construct them and program with them.


@section{Natural Numbers as inductive types}
0, 1, 2, ..., etc. are considered natural numbers using 
numerals conventionally. But there is another way of
thinking of natural numbers in which natural numbers are
built one at a time, step by step.   

Mathematically, the set @bold{N} of natural numbers is the
@emph{smallest} set of values satisfying the conditions

@itemlist[#:style 'ordered
	@item{@bold{Z()} belongs to @bold{N}}
	@item{if ( @italic{n} belongs to  @bold{N}) then @bold{s}(@italic{n}) belongs to @bold{N}}
	]

An equivalent short hand for the above is the set of the
following @emph{rules}:

@verbatim{

      ---------  ZERO
       z() : N



       n : N
      --------   SUCC
       s(z) : N
       
}


Here, we have two rules, called ZERO and SUCC (for
successor).  Each rule consists of two parts divided by a
horizontal line, which may be read as an "if-then". The
part(s) above the line is called @emph{hypothesis or
antecedent}; the part below the line is called the
@emph{consequent or conclusion}.  The colon denotes
membership in the set @bold{N}.  @bold{Z} and @bold{s} are
@emph{constructors}.  You may think of constructors as
functions.  In the above case, @bold{Z} takes nothing and
returns an element of @bold{N}.  @bold{s} takes an element
of @bold{N} and returns another element of @bold{N}.

Depending on our @emph{choice} of @bold{Z} and @bold{s},
different @emph{representations} of @bold{N} are
possible.  The constraints on the constructors are the
following:

@itemlist[#:style 'ordered
	@item{Each constructor is injective.}
	@item{Each constructor is distinct from the other.}
	]

The above two constraints guarantee that every element of the
inductive type is @emph{uniquely} constructed using the
constructors.  From this we may then conclude that @emph{if
n is an element of @bold{N}, then exactly one of the following is true}:


@itemlist[#:style 'ordered
	@item{n = @bold{z()}}
	@item{n = @bold{s(m)} for a unique m.}
	]

In the particular case of @bold{N}, the @emph{m} above is called
@emph{the predecessor of} @emph{n}.



@section{Summary}

Inductive types are built using constructors.  Every element
of an inductive set is uniquely constructible using the
constructors, which are injective and mutually distinct.  An
inductive type may have several different representations.

