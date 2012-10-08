#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "theory-10"]{Theory}

@local-table-of-contents[]

@section{Object Oriented Programming}

Object-oriented programming (OOP) is a programming language model,
organized around @emph{objects} rather than @emph{actions},
@emph{data} or @emph{logic}.

Object-oriented programming takes the view that it is the objects we
really care about as we want to manipulate them rather than the logic
required to manipulate them.

@itemlist[#:style 'ordered
	@item{The first step in OOP is to identify all the objects you want to manipulate and how they relate to each other.}
	@item{Once you have identified an object, you generalize it as a class of objects 
		and define the kind of data it contains and any logic sequences that can manipulate it.}
]

Each distinct logic sequence is known as a @emph{method}.

A real instance of a class is called an @emph{object}.  You
communicate with objects - and they communicate with each other - with
well-defined interfaces called messages.

@section{Objects}

In order to identify the objects one wants to manipulate, it is
necessary to identify their @emph{state} and @emph{behavior}. An
object essentially stores its state(s) in @emph{variables} and the
behavior is exhibited through the @emph{methods}. Methods operate on
an object's internal state and serve as the primary mechanism for
object-to-object communication. Hiding internal state and requiring
all interaction to be performed through an object's methods is known
as @emph{data encapsulation}.

Building the code into individual objects, provides a number of
benefits:

@itemlist[#:style 'ordered
	@item{Modularity: The source code of one object is independent
	of the other objects.}

	@item{Information-Hiding: Since we can only interact with the
	object's methods, the details of internal implementation are
	hidden.}

	@item{Code re-use: A existing object can be re-used in another program.}
]
