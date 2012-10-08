#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "quiz-7"]{Quiz}

@local-table-of-contents[]

@itemlist[#:style 'ordered
@item{
Consider a language, with the following concrete syntax:

exp ::= number | boolean | identifier | assume | function | apply

function ::= ((list-of identifiers) (exp))

apply ::= ((list-of exp) (exp))

assume ::= ((list-of identifiers and exp) (exp))

op ::= + | - | * | / | < | <= | eq? | 0?

i.e. a language with arithmetic and relational operators as well as environments and closures.

Design and implement the abstract syntax, parser and evaluator.

@bold{Instructions for Uploading and Testing:}

Kindly name your file to be @emph{"closure.ss"}

Upload the file containing the code in the file-upload interface provided. 

Make sure you export each function/predicate etc, which you defined using @racket[provide]

For testing, execute the following code (in the scheme window beside) to obtain the test results:

@racketblock[
(require "test/test-closure.ss")
(test-closure)
]
}
]
