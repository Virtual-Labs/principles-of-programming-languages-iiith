#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "lexical-objective"]{Objective}

The objectives of this experiment are to design a language
with block structure (lexical scope).  This involves

@itemlist[#:style 'ordered
	@item{Designing the abstract syntax for a block structured language}
	@item{Designing the parser for the block structured language}
	@item{Designing the interpreter for the block structure language}
]


At the end of this experiment, the student should have a complete
understanding of the principle of lexical scope using the artifact of
environments that we have learnt in the previous experiment on
environments.  The student should be able to understand evaluation of
expressions involving lexcial scope (local declarations, as they are
otherwise known in many popular languages).

