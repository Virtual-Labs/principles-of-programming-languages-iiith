#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "procedure-5" ]{Procedure}

@local-table-of-contents[]

@bold{@emph{Problem:}} Design an abstract datatype for
environments in Scheme.


We follow the "standard" approach to designing an abstract
datatype using the @verbatim{define-datatype} construct.


@section[#:tag "env-procedure-type-name" #:style '(toc)]{Choosing a Type name and Type predicate}

This consists of choosing a name for the datatype (env) and
the type predicate (env?). 


@section[#:tag "env-procedure-empty-env" #:style '(toc)]{Defining the constructor for empty environment}

The first variant of an environment is the empty
environment.  The empty environment is constructed using a
constructor, which we name as @emph{empty-env}

@defproc[(empty-env) env?]


@section[#:tag "env-procedure-extended-env" #:style '(toc)]{Constructor for extended environment}

In the theory, we considered the composition of
environments.  Composition is a form of construction.  In
all the use cases for environments we will encounter, we
will come across the need to @emph{construct} a new
environment from an existing environment and a set of
identifiers and their (respective) denotable values, instead
of two environments.  Therefore, we talk of an
@emph{extended} environment built from a list of
identifiers, a list of denotable values, and an existing
(old) environment.

@defproc[(extended-env 
           [ids (listof symbol?)]
           [vals (listof denotable-value?)]
	   [old-env env?]) env?]

@section[#:tag "env-procedure-datatype" #:style '(toc)]{Putting the data type together}

Now, we have all the pieces to specify an environment using
@racket[define-datatype].

@racketblock[
(define-datatype env env?
	[empty-env ()]
	[extended-env 
	  (ids (listof symbol?))
          (vals (listof denotable-value?))
	  (old-env env?)])
]

@;section[#:tag "env-procedure-subtypes" #:style '(toc)]{Defining the subtypes}

@section[#:tag "env-procedure-lookup" #:style '(toc)]{Defining the lookup function}

The function @racket[lookup-env] takes an environment and an
identifier and returns either a denotable value raises an
"identifier not bound" error.

@defproc[(lookup-env 
           [id symbol?]
           [env env?])
         denotable-value?]



Next, we look at programming the implementation of the
abstract datatype @racket[env] introduced here.

