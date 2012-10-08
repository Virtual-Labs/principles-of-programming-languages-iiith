#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "quiz-4"]{Quiz}

@itemlist[#:style 'ordered
@item{
Consider a language, with the following concrete syntax:

exp ::= number | boolean | prim-app-exp

prim-app-exp ::= (op exp ...)

op ::= + | - | * | / | < | <= | eq? | 0?


i.e., a language with arithmetic and relational operators.

Design and implement the abstract syntax, parser and evaluator.

@bold{Instructions for Uploading and Testing:}

Kindly name your file to be @emph{"arithmetic.ss"}

Upload the file containing the code in the file-upload interface provided. 

Make sure you export each function/predicate etc, which you defined using @racket[provide]

For testing, execute the following code (in the scheme window beside) to obtain the test results:

@racketblock[
(require "test/test-arithmetic.ss")
(test-arithmetic)
]
}
]
