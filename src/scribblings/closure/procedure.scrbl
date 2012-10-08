#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "procedure-7"]{Procedure}

@local-table-of-contents[]

@bold{A language for @emph{closure} constructs}

@section{Specifying the Syntax}

A closure expression either consists of numbers or boolean values or
expressions with primary operators/apps like +,-,/,* etc and operands
as well as assume blocks ,identifiers, functions and apply operations.
Thus, the grammar of such a language can be written as:

ast ::= num-ast | bool-ast | prim-app-ast | assume-ast | id-ref-ast | function-ast | app-ast

where 

@emph{num-ast} implies an ast consisting of only numbers, for example:
5, 6, 2, 0 etc.

@emph{bool-ast} implies an ast consisting of only boolean values,
i.e. 0 and 1.

@emph{assume-ast} consists of a list of bindings and a body which are
again of the form @emph{ast}.

@emph{id-ref-ast} consists of an identifier only, example 'x'.

@emph{function-ast} consists of a list of formals which are
identifiers and a body which is a @emph{ast}.

@emph{app-ast} consists of an operator and an operation (which in turn
are again of the form - @emph{ast}). This is used since operations are
now not always inbuilt, so using prim-app is not going to be always
correct.

We have to define a constructor for each of the above variants of ast
which are:

@defproc[(number [num number?]) ast?]
@defproc[(boolean [bool boolean?]) ast?]
@defproc[(app [rator ast?][rands (list-of ast?)]) ast?]
@defproc[(id-ref [sym id?]) ast?]
@defproc[(assume [binds (list-of bind?)][body ast?]) ast?]
@defproc[(function [formals (list-of id?)][body ast?]) ast?]

Hence, the abstract syntax of this language would be:

@racketblock[
(define-datatype ast ast?
  [number (datum number?)]
  [boolean (datum boolean?)]
  [function
   (formals (list-of id?))
   (body ast?)]
  [app (rator ast?) (rands (list-of ast?))]
  [id-ref (sym id?)]
  [assume (binds  (list-of bind?)) (body ast?)])
]

Notice, like earlier, the binds data type in the assume operation. Let
us define that too.

@racketblock[
  (define-datatype bind bind?
    [make-bind (b-id id?) (b-ast ast?)])
]

@section{Specification of Values}

While designing any programming language, its highly important to
specify the set of values that the language manipulates.

Each language has, the following sets of values:

@emph{Expressible Values} : set of values that are the results of evaluation of expressions (ASTs).

In our case, since any expression evaluates to either a number or a
boolean, the set of expressible values would be (number, boolean or
procedures).  Thus, we can also define a predicate to test for
expressible-values as follows:

@racketblock[
(define expressible-value?
  (or/c number? boolean? proc?))]

@emph{Denotable Values} : set of values which are bound to variables.

@racketblock[
(define denotable-value?
  (or/c number? boolean? proc?))]

NOTE: The set of expressible and denotable values can be different.

@section{Designing the Parser}

The concrete syntax of this language  is as follows:

exp ::= <number> | <boolean> | <identifier> | (<op> exp ...) | (assume (listof<id> listof<exp>) exp) | (function (listof<id>) <ast>) | (app  <ast>  listof<ast>)

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

If it is an assume expression, we simply write out the assume function
along with the 'bind' to create an expression that can be evaluated.

In case of an identifer, we replace it with a (id-ref <identifier>),
so that the evaluator's job is easier.

If the expression is a function expression, we replace it with a
closure which has a list of operands, and an ast to apply on these
operands.

In case of an application expression, we parse the closure to figure
out if it is a primitive procedure or not; and then call the parse
function for the list of expressions (i.e. the operands).

@section{Designing the Evaluator}

The evaluator takes an ast and returns the value obtained by
evaluating the ast, i.e. an @emph{expressible value}.  Hence its
signature would look like:

@defproc[(eval-ast [ast ast?]) expressible-value?]

For the naive case, where the ast consists of just a number or a
boolean, the returned value would necessarily be the value of the
number or the boolean.

However, in the case of an expression, we would need to first evaluate
each of the operands and then apply the operator on the evaluated
values.  Thus, we would need a procedure @racket[apply-proc] which
takes an operator and a list of expressible values, and applies the
operator on them.

If it is an assume expression, we create an environment with the
identifiers and variables given, and proceed to evaluate the body.

In case of an identifer, we call the lookup-env function to evaluate
it to a value.

If it is a closure, we evalute to check if the operator is a primitive
operator and apply @racket[apply-prim-proc], else we apply the
function using @racket[apply-closure].
