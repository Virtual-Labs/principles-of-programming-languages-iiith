#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "letrec-objective"]{Objective}

The objectives of this experiment are to design a language
with recursive functions.  This involves:

@itemlist[#:style 'ordered
	@item{Designing the abstract syntax for a language supporting recursive functions.}
	@item{Redesigning the environments to support recursive functions.}
	@item{Designing the parser for the language supporting recursive functions.}
	@item{Designing the interpreter for the language supporting recursive functions.}
]


At the end of this experiment, the student should completely
understand the abstract datatype of recursive functions. Also, the
environments are redifined to support recursive functions, thus making
the student capable of understanding the recursive environments as
well.  The student should also be able to understand evaluation of
expressions involving these recursive functions using the recursive
environments.
