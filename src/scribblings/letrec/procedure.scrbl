#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "procedure-8"]{Procedure}

@local-table-of-contents[]

@bold{A language for @emph{recursive function} constructs}

@section{Specifying the Syntax}

A recursive expression either consists of numbers or boolean values or
expressions with primary operators/apps like +,-,/,* etc and operands
as well as assume blocks ,identifiers, (recursive and normal)
functions and apply operations.  Thus, the grammar of such a language
can be written as:

ast ::= num-ast | bool-ast | ifte-ast | assume-ast | id-ref-ast | function-ast | recursive-ast | app-ast

where 

@emph{num-ast} implies an ast consisting of just numbers, for example: 5, 6, 2, 0 etc.

@emph{bool-ast} implies an ast consisting of just boolean values, i.e. 0 and 1.

@emph{ifte-ast} is an ast with a test expression, then and else expressions each of which is an @emph{ast}.

@emph{assume-ast} consists of a list of bindings and a body which are again of the form @emph{ast}.

@emph{id-ref-ast} consists of an identifier only. example 'x'.

@emph{function-ast} consists of a list of formals which are identifiers and a body which is a @emph{ast}'s.

@emph{recursive-ast} consists of a list of function bindings and a
body which is an @emph{ast} while the bindings are lists of function
names, formals and bodies which are of types @emph{id-ref} and
@emph{ast}'s.

@emph{app-ast} consists of an operator and an operation (which in turn
are again of the form - @emph{ast}). This is used since operations are
now not always inbuilt, so using prim-app may or may not be always
correct.

In order to come up with an abstract syntax, for a given concrete
syntax, we must name each production of the concrete syntax and each
occurrence of a non-terminal in each production.  Thus we would have
to create one @racket[define-datatype] for each non-terminal, with one
variant for each production.

Hence, the abstract syntax of this language would be:

@racketblock[
(define-datatype ast ast?
  [number (datum number?)]
  [boolean (datum boolean?)]
  [ifte (test ast?) (then ast?) (else-ast ast?)]
  [function
   (formals (list-of id?))
   (body ast?)]
  [recursive (fbinds (list-of fbind?)) (body ast?)]
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

Also, since we now have function bindings, we require an fbinds too.

@racketblock[
(define-datatype fbind fbind?
  [make-fbind (fb-id id?)
              (fb-formals (list-of id?))
              (fb-body ast?)])
]

@section{Specification of Values}

While designing any programming language, its highly important to
specify the set of values that the language manipulates.

Each language has, the following sets of values:

@emph{Expressible Values} : set of values that are the results of
evaluation of expressions (ASTs).

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

NOTE: the set of expressible and denotable values can be different.

@section{The recursive environment}

Now, our abstract datatype for an environment also needs to be
modified to support recursive environments.  So, in our environment
definition, we add:

@racketblock[
  [extended-rec-env
    (fsyms (list-of symbol?))
    (lformals (list-of (list-of symbol?)))
    (bodies (list-of ast?))
    (outer-env env?)]
]

Our lookup now looks like:

@racketblock[
(define lookup-env
  (lambda (e x)
    (cases env e
      [empty-env ()
        (error
          'lookup-env
          "unbound identifier ~a" x)]
      [extended-env (syms vals outer-env)
        (let ([j (list-index syms x)])
          (cond
            [(= j -1) (lookup-env outer-env x)]
            [#t (list-ref vals j)]))]
      [extended-rec-env
       (fsyms lformals bodies outer-env)
        (let ([j (list-index fsyms x)])
          (cond
            [(= j -1)
             (lookup-env outer-env x)]
            [#t
             (let ([formals
                    (list-ref lformals j)]
                   [body (list-ref bodies j)])
                  (closure formals body e))]))])))
]

Note that we are now building a closure at @emph{time of lookup!}

@section{Designing the Parser}

The concrete syntax of this language  is as follows:

exp ::= <number> | <boolean> | <identifier> | (<op> exp ...) | (assume (listof<id> listof<exp>) exp) | (function (listof<id>) <ast>) | (app  <ast>  listof<ast>) | (recursive (listof ( (listof<id> list of<exp>) exp ) exp)

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

If it is an assume expression, we simply output the assume function
along with the 'bind' to create an evaluatable expression.

In case of an identifer, we replace it with a (id-ref <identifier>) so
that the evaluator's job is simplified further.

If the expression is a function expression, we replace it with a
closure which has a list of operands, and an ast to apply on these
operands.

If the expression is a recursive function, we get a list of function
bindings using fbinds and a body which to evaluate in a newly created
recursive environment consisting of the aforementioned function
bindings.

In case of an application expression, we parse the closure to figure
if it is a primitive procedure and then call the parse function for
the list of expressions (i.e. the operands).

@section{Designing the Evaluator}

The evaluator takes an ast and returns the value obtained by
evaluating the ast, i.e. an @emph{expressible value}.  Hence the
signature would look like:

@defproc[(eval-ast [ast ast?]) expressible-value?]

For the naive case, where the ast consists of only a number or a
boolean, the returned value would necessarily be the value of the
number or the boolean.

However, in the case of an expression, we first need to evaluate each
of the operands and then apply the operator on the obtained evaluated
values.  Thus, we need a procedure @racket[apply-proc] that takes
an operator and a list of expressible values, and applies the operator
on them.

If it is an assume expression, we create an environment with the
identifiers and variables given and proceed to evaluate the body.

In case of an identifer, we call the lookup-env function to evaluate
it to a value.

If it is a closure, we evalute to check if the operator is a primitive
operator and apply @racket[apply-prim-proc], else we apply the
function using @racket[apply-closure].

Note that for a recursive function, the evaluation procedure remains
the same, except for the creation and use of the recursive
environment. The actual recursion takes place when using the lookup.
