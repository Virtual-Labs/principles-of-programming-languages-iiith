#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "procedure-4"]{Procedure}

@local-table-of-contents[]

@section{Example: A language for @emph{arithmetic} constructs}

@subsection{Specifying the Syntax}

An arithmetic expression either consists of numbers or boolean values or expressions with primary operators/apps like +,-,/,* etc and operands.
Thus, the grammar of such a language can be written as:

ast ::= num-ast | bool-ast | prim-app-ast

where 

@emph{num-ast} implies an ast consisting of just numbers, for example: 5, 6, 2, 0 etc.

@emph{bool-ast} implies an ast consisting of just boolean values, i.e. 0 and 1.

@emph{prim-app-ast} consists of an arithmetic operator and its operands (which in turn are again of the form - @emph{ast})	

We have a constructor for each of these variants whose signatures are given below:
@defproc[(number [num number?]) ast?]
@defproc[(boolean [bool boolean?]) ast?]
@;defproc[(prim-app [op op-symbol?] [rands(list-of ast?]) ast?]

Hence, the abstract syntax of this language could be defined as:

@racketblock[
(define-datatype ast ast?
	[number (datum number?)]
	[boolean (datum boolean?)]
	[prim-app (op op-symbol?) (rands (list-of ast?))])
]

@subsection{Specification of Values}

While designing any programming language, it is highly important to specify the set of values that the language manipulates.

Each language has the following sets of values:

@emph{Expressible Values} : set of values that are the results of evaluation of expressions (ASTs).

In our case, since any expression evaluates to either a number or a boolean, 
the set of expressible values would be {number, boolean}. 
Thus, we can also define a predicate to test for expressible-values as follows:

@racketblock[
(define expressible-value?
  (lambda (thing)
    (or (number? thing)
      (boolean? thing))))
]

@emph{Denotable Values} : set of values which are bound to variables.

NOTE: the set of expressible and denotable values can be different.

@subsection{Designing the Parser}

The concrete syntax of this language  is as follows:

exp ::= <number> | <boolean> | (<op> exp ...)

op  ::= one of <op-symbols>

where <op-symbols> = (+,-,/,*)

As discussed earlier, the task of a parser is to convert any given program sequence into an ast.
Hence, the signature of our parser procedure would be:

@defproc[(parse [code any/c?]) ast?]

Now, while going through the input sequence if we find the current literal to be a terminal i.e. a boolean or a number, 
then we output the corresponding node of the ast i.e. @racket[(number literal)] or @racket[(boolean literal)].
In case of an operator expression, we parse the operator as @racket[(prim-app op)], 
and then call the parse function for the list of expressions (i.e. the operands).

@subsection{Designing the Evaluator}

The evaluator takes an ast and returns the value obtained by evaluating the ast, i.e. an @emph{expressible value}.
Hence its signature would look like:

@defproc[(eval-ast [ast ast?]) expressible-value?]

For the naive case, where the ast consists of just a number or a boolean, the returned value would necessarily be the value of the number or the boolean.
However, in the case of an expression, we'd need first evaluate each of the operands and then apply the operator on the obtained evaluated values.
Thus, we'd need a procedure @racket[apply-prim-op] which takes an operator and a list of expressible values, and applies the operator on them.

