#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "closure-objective"]{Objective}

The objectives of this experiment are to design a language
with first class functions (closures).  This involves

@itemlist[#:style 'ordered
	@item{Designing the abstract syntax for a language supporting first class functions.}
	@item{Designing the parser for the language supporting first class functions.}
	@item{Designing the interpreter for the language supporting first class functions.}
]


At the end of this experiment, the student should have a complete
understanding of the abstract datatype of closures. The closure
datatype is the building block for implementing first order functions.
The student should also be able to understand evaluation of
expressions involving such closures.
