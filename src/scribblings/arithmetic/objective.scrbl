#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "objective-4"]{Objective}

The objectives of this experiment are the following:

@itemlist[#:style 'ordered
	@item{Designing a language - ARITHMETIC - that can handle arithmetic constructs/expressions.}
	@item{Coming up with the abstract and concrete syntax of the language.}
	@item{Designing the basic parser and evaluator for the language.}
]

At the end of this experiment, the student should know how to 
define the abstract syntax of a language, 
be able to understand abstract syntax trees and the need for a parser and an evaluator.
