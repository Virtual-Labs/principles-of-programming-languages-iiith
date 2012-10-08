#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "procedure-1"]{Procedure for designing and implementing inductive data types}

@local-table-of-contents[]

@bold{@emph{Problem:}} Design representations for inductive
data types and implement them in Scheme.

@bold{@emph{Approach:}} Our goal is to provide a symbolic
representation for each element of the datatype.  This is
typically a structure built using primitives of data structures,
 that are already inbuilt into the language, like
lists and vectors.


@section[#:tag "lab-exp1-procedure"]{Example: Natural Numbers}
@emph{Steps for design}

@subsection[#:tag "inductive type name and predicate"]{Step 1: Name the inductive type and the
corresponding type predicate}

We pick the name @racket{nat} to denote the set of
natural numbers.  We pick the type predicate @racket{nat?}
with the signature


@;defproc[(nat? [thing any/c]) boolean?]

The type @racket{any/c} denotes the type of @emph{any}
scheme value.  The predicate @racket{boolean?} denotes the
type of booleans.  Types are denoted by predicates, called
@emph{type predicates}.  Likewise, the type predicate
@racket{nat?} takes an argument (called @racket{thing}) and
determines if it is a natural number @emph{according to our
representation}.

@subsection[#:tag "Constructor and Subtype Predicates"]{Step 2: Choose constructor and subtype predicate
names and define their signatures}

The next step is to choose a name for each constructor, a
type predicate for each subtype of the inductive type.  For
the @racket{nat} inductive type, we have two
@emph{constructors}

@;defproc[(z) z?]

and

@;defproc[(s [p nat?]) s?]


The two types @racket{z?} and @racket{s?} are
@emph{subtypes} of @racket{nat?}.  In particular, any
element of @racket{nat?} is @emph{guaranteed} to be
@emph{one of} its @emph{variants} @racket{z?} or
@racket{s?}.

@subsection[#:tag "Extractor names and signatures"]{Step 3: Choose extractor names  and define their signatures}

An extractor maps a variant to one of its component
elements.  In this example, the extractor would take an
element of subtype @racket{s?} and return the component.


@;defproc[(s-pred [n s?]) nat?]


@subsection[#:tag "Datatype representation"]{Step 4: Choose representation of inductive datatype}

This step is where we need to ground the definition of our
inductive type into a concrete data structure representation
in the programming language (Scheme, in this case).

To continue with the example, we choose a representation
where the natural number @emph{n} is represented by a list
of @emph{n} @racket{a}'s.  For example, zero would be the
represented as @racket{()}, whereas 2 would be represented
as the list @racket{(a a)}. 

@subsection[#:tag "Define constructors and extractors"]{Step 5: Define constructors and extractors based on
the representation}

@racketblock[
(define z
 (lambda ()
    '()))

(define s
  (lambda (n)
    (cons 'a n)))
]

