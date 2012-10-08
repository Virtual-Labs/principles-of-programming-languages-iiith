#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "objective-1"]{Objective}


The objectives of this experiment are the following:

@itemlist[#:style 'ordered
	@item{Designing signatures for type predicates, constructors, extractors, and subtypes}
	@item{Choosing a representation for inductive data}
	@item{Defining implementations of constructors and extractors for inductive data}
]


At the end of this experiment, the student should know how
to choose data structure representations for inductive data
and be able to define the signatures of type and subtype
predicates, constructors, and extractors.

