#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "theory-5"]{Theory}

@local-table-of-contents[]


Real programming languages have identifiers, like @emph{x},
@emph{y}, etc.  When a program runs, these identifiers are
bound to @emph{denotable values}.  In other words, the
identifiers in a program denote values (whose type is
"denotable values") In this experiment our goal is to design
and implement a datatype that models the binding of
identifiers to values.  Such a datatype is called an
@emph{environment}.  An environment is sometimes also known
as a symbol table.

More formally, a @emph{binding} is a pair consisting of an
identifier and a value.  Mathematically, therefore, an
environment is best thought of as a @emph{partial} function
from the type identifier to the type of values.  We assume
throughout that identifiers are represented by symbols.

@section[#:tag "env:theory:example" #:style '(toc)]{Example}

Consider the environment @emph{e} given below

@verbatim{

   {(x,3), (y, 5)}}


This environment consists of two bindings.  Naturally, the
ordering of the bindings isn't relevant.  Looking up x in
@emph{e} returns 3; looking up y returns 5.  The binding of
any other identifier in @emph{e} is undefined.  We may
assume that carrying out a lookup for an identifier not in
the domain of @emph{e} results in the raising of an error.

With a basic understanding of environments, let us now
formally understand the operations that one can do on
environments.

@section[#:tag "env:theory:basic-operations" #:style '(toc)]{Basic operations on an environment}

Our goal is to design an abstract datatype for environments.
In this section, we informally consider the basic operations
on the environment datatype.

@subsection[#:tag "New environment" #:style '(toc)]{Making a new environment}

A new (empty) environment is an environment which does not
have any bindings.   

@subsection[#:tag "looking-up" #:style '(toc)]{Looking up the value of a symbol in an environment}

When a symbol is looked up in an environment, one of two
things can happen: either the symbol has a mapping to a
value in the environment, or it doesn't.  In the former
case, the lookup operation simply returns the value.  In the
latter case, the lookup raises an error or an exception.

@subsection[#:style '(toc)]{Composing environments}

The most interesting aspect of environments is how they
compose.  Given an environment @emph{e} and @emph{e'}, the
environment @emph{e . e'} (read e composed with e') is an
environment whose domain consists of the union of the
domains of e and e'.  We abbreviate @emph{e . e'} with
@emph{e''}. What is the result of looking up an identifier,
say @emph{x}, in @emph{e''}?  If @emph{x} is in e, then the
result is the same as looking up x in @emph{e}.  Otherwise,
the result is the same as looking up x in @emph{e'}.  


As an example,  consider 

@verbatim{
   e  = {(x,3), (y, 5)}
   e' = {(y,7), (z, 2)}
   e''  = e . e'
  }


Looking up x in @emph{e''} returns 3.  Looking up y in
@emph{e''} retuns 5.  Looking up z in @emph{e''} returns 2.
The domain of @emph{e''} consists of the identifiers x,y,
and z.  Note that one may think of the bindings of e
@emph{shadowing}, or hiding, the bindings of e'.    

@section[#:style '(toc)]{Summary}

Environments are abstract data types that are used to model
bindings of identifiers to values in programming languages.
The operations on an environment are (i) creating a new
environment, (ii) looking up an identifier, and (iii)
composition of two environments.

