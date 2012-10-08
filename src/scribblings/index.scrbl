#lang scribble/manual

@(require scribble/bnf
          scribblings/scribble/utils
	  scribble/html-properties
	  scribblings/main/private/utils
          )

@;(require (for-label racket))
@(require scribble/eval)
@(require racket/include)

@title{Virtual Laboratory for Principles of Programming
Languages (PoPL)}


@; @author["Venkatesh Choppella"]

Welcome to the virtual lab on PoPL!

@; uncomment next two lines if you want MathJax to work

@;(script-ref "MathJax/MathJax.js")
@; $$ x^{2} + y^{2}  = z^{2} $$

@; also make sure that MathJax/MathJax.js is accessible from
@; the generated index.html the easiest way to do this is
@; for your makefile to create a soft link to an existing
@; MathJax directory


@include-section["introduction.scrbl"]

@;table-of-contents[]  

@local-table-of-contents[#:style 'immediate-only]  

@include-section["inductive-data/index.scrbl"]	@; Building Inductive types
@include-section["recursion/index.scrbl"]       	@; Recursion: Programming with inductive data
@include-section["higher-order/index.scrbl"]        	@; Higher-order functions
@include-section["arithmetic/index.scrbl"]        @; ARITHMETIC: A Language for Arithmetic
@include-section["environments/index.scrbl"]      @; ENVIRONMENT: Abstract Data Type for Lexical Environment
@include-section["lexical/index.scrbl"]           @; LEXICAL:    A Language with Block Structure
@include-section["closure/index.scrbl"]           @; CLOSURE:   A Language with First class functions
@include-section["letrec/index.scrbl"]            @; LETREC: A Language with Recursive functions
@include-section["objects/index.scrbl"]                @; OBJECTS: A language for object-oriented programming

@; ------------------------------------------------------------------------

@index-section[]

@bold{References:}

@itemlist[
	@item{Essentials of Programming Languages: 
		@(let ([url "http://www.eopl3.com/"])
				(link url url))
	}
	@item{Racket: 
		@(let ([url "http://racket-lang.org/"])
				(link url url))
	}
]
