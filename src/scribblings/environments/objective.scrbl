#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "objective-env" #:style '(toc)]{Objective}


The objectives of this experiment are the following:

@itemlist[#:style 'ordered
	@item{Designing the abstract datatype for environments}
	@item{Choosing a representation for implementing environments}
	@item{Defining implementations of constructors and extractors for inductive data}
]


At the end of this experiment, the student should completely
understand the abstract datatype for environments. The
environment datatype is an essential building block for
interpreters designed in all the subsequent experiments. In
addition, the student should be able to comfortably choose
different representations of environments and implement the
environment abstract datatype with those representations.


