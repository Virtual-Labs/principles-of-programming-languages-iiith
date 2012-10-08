#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "procedure-6"]{Procedure}

@local-table-of-contents[]

@bold{A language for @emph{lexical} constructs}

@section{Specifying the Syntax}

A lexical expression either consists of numbers or boolean values or
expressions with primary operators/apps like +,-,/,* etc and operands
as well as assume blocks and identifiers.  Thus, the grammar of such a
language can be written as follows:

ast ::= num-ast | bool-ast | prim-app-ast | assume-ast | id-ref-ast

where 

@emph{num-ast} implies an ast consisting of only numbers, for example: 5, 6, 2, 0 etc.

@emph{bool-ast} implies an ast consisting of only boolean values, i.e. 0 and 1.

@emph{prim-app-ast} consists of an arithmetic operator and its operands (which in turn are again of the form - @emph{ast})

@emph{assume-ast} consists of a list of bindings and a body which are again of the form @emph{ast}

@emph{id-ref-ast} consists of an identifier only, for example 'x'.

We have to define a constructor for each of the above variants of ast which are:

@defproc[(number [num number?]) ast?]
@defproc[(boolean [bool boolean?]) ast?]
@defproc[(prim-app [op op-symbol?][rands (list-of ast?)]) ast?]
@defproc[(id-ref [sym id?]) ast?]
@defproc[(assume [binds (list-of bind?)][body ast?]) ast?]

Hence, the abstract syntax of this language would be:

@racketblock[
  (define-datatype ast ast?
    [number (datum number?)]
    [boolean (datum boolean?)]
    [prim-app (op op-symbol?) (rands (list-of ast?))]
    [id-ref (sym id?)]
    [assume (binds  (list-of bind?)) (body ast?)])
]

Notice the binds datatype in the assume operation. Let us define that too.

@racketblock[
  (define-datatype bind bind?
    [make-bind (b-id id?) (b-ast ast?)])
]

@section{Specification of Values}

While designing any programming language, its highly important to
specify the set of values that the language manipulates.

Each language has, the following sets of values:

@emph{Expressible Values} : set of values that are the results of
evaluation of expressions (ASTs).

In our case, since any expression evaluates to either a number or a
boolean, the set of expressible values would be (number, boolean).
Thus, we can also define a predicate to test for expressible-values as
follows:

@racketblock[
(define expressible-value?
  (lambda (thing)
    (or (number? thing)
      (boolean? thing))))
]

@emph{Denotable Values} : set of values which are bound to variables.

@racketblock[
  (define denotable-value?
    (lambda (thing)
      (or (number? thing)
        (boolean? thing))))
]

NOTE: the set of expressible and denotable values can be different.

@section{Designing the Parser}

The concrete syntax of this language  is as follows:

exp ::= <number> | <boolean> | <identifier> | (<op> exp ...) | (assume (listof<identifiers> listof<exp>) exp)

op  ::= one of <op-symbols>

where <op-symbols> = (+,-,/,*, <, <=, eq?, 0?)

As discussed earlier, the task of a parser is to convert any given
program sequence into an ast.  Hence, the signature of our parser
procedure would be:

@defproc[(parse [code any/c?]) ast?]

Now, while going through the input sequence if we find the current
literal to be a terminal i.e. a boolean or a number, then we output
the corresponding node of the ast i.e. @racket[(number literal)] or
@racket[(boolean literal)].

In case of an operator expression, we parse the operator as
@racket[(prim-app op)], and then call the parse function for the list
of expressions (i.e. the operands).

If it is an assume expression, we simply write out the assume function
along with the 'bind' to create an expression that can be evaluated.

In case of an identifer, we replace it with a (id-ref <identifier>) so
that the evaluator's job is easier.

@section{Designing the Evaluator}

The evaluator takes an ast and returns the value obtained by
evaluating the ast, i.e. an @emph{expressible value}.  Hence its
signature would look as follows:

@defproc[(eval-ast [ast ast?]) expressible-value?]

For the naive case, where the ast consists of just a number or a
boolean, the returned value would necessarily be the value of the
number or the boolean.

However, in the case of an expression, we would first need to evaluate
each of the operands and then apply the operator on the obtained
evaluated values.  Thus, we would need a procedure
@racket[apply-prim-op] which takes an operator and a list of
expressible values, and later applies the operator on them.

If it is an assume expression, we create an environment with the
identifiers and variables given, and proceed to evaluate the body.

In case of an identifer, we call the lookup-env function to evaluate
it and get a value.
