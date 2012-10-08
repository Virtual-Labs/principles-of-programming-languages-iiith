#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "theory-4"]{Theory}

@local-table-of-contents[]

The usual pipeline for a regular programming language to be compiled/interpreted involves the following phases:

(program text) --> [FRONT END] --> (syntax tree) --> [INTERPRETER] --> (output)

The @emph{FRONT END} converts the program text into abstract syntax trees. 
Now, because our program is just the strings of characters (which are meaningless to the INTERPRETER), the @emph{FRONT END} needs to 
group these characters into meaningful units - i.e. @emph{parsing}.


@section{Abstract Syntax}
For any programming language, a @emph{concrete syntax} is a particular representation of its inductive datatype.
However, while designing a programming language, in order to process it we need an @emph{internal representation} of this concrete form.
Such an internal representation is called the @bold{abstract syntax}.
This kind of an internal representation describes the data structures for representing, encoding, transmitting and decoding the data.

In scheme the @racket[define-datatype] form provides a convenient way of defining such an internal representation.

For example: the abstract syntax of the following scheme expression can be visualized in the form of a tree - called the @bold{abstract syntax tree}:

@racket[(+ 6 2)]

@section{Parsing}
@emph{Parsing} is the process of analyzing an input sequence (in our case, the program text) in order to determine its grammatical structure.
The parser is responsible for organizing this sequence into hierarchical syntactic structures such as expressions, statements and blocks.
It necessarily creates an abstract syntax tree of the input sequence.

For example given an english sentence "Adam is a good boy", 
we can parse it and organise it as clauses,

(Adam, NOUN) (is, VERB) (a, DETERMINER) (good, ADJECTIVE) (boy, NOUN).

Similarly for the above expression @racket[(+ 6 2)], we can parse it as:

@racket[(+ operator) (6 operand) (2 operand)]

where: 

operator ::= + | - | / | *

operand ::= exp

and we can represent an exp in Backus Naur form as:
	
exp ::= number | boolean | (operator exp exp)


NOTE: the concrete syntax is primarily useful for the end-users, while the abstract syntax is primarily useful for computers, 
and it is the parser which is responsible for converting the concrete syntax to an abstract syntax.

@section{Evaluation}
The @emph{evaluator} is responsible for evaluating the abstract syntax tree produced by the parser 
in order to come up with the output of the input program sequence.

For example: for the following scheme expression, the evaluator output would be the folllwing

@racket[(+ 6 2) ---> internal representation ---> Evaluation ---> 8]
