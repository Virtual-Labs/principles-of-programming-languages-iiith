#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))
@title[#:tag "theory-6"]{Theory}

@local-table-of-contents[]

While using programming languages and bound identifiers as seen in the
previous experiment, we often write functions of multiple variables
sharing the same identifiers. Thus same identifiers are used at
several places in the function. How would we then distinguish between
the values stored in each of these identifiers? This association of an
environment with a block of code is known as "lexical scoping". We say
that a program has lexical scope when the scope of an identifier can
be determined by a lexical analysis of that particular block of code.


Building a Lexical Language will again require the following four steps:

@section[#:tag "lex:theory:abstractsyntax" #:style '(toc)]{Abstract Syntax}

As mentioned in the previous experiment, concatenated environments due
to nested blocks can be thought of as a stack of environments with the
top-most common identifiers hiding the ones behind it.

@section[#:tag "lex:theory:parsing" #:style '(toc)]{Parsing}

This converts the input sequence (in concrete syntax) into abstract
syntax tree, so that the evaluator can evaluate it.

@section[#:tag "lex:theory:evaluation" #:style '(toc)]{Evaluation}

The @emph{evaluator} is responsible for evaluating the abstract syntax
tree produced by the parser in order to come up with the output of the
input program sequence.

For example: for the following scheme expression;

@racket[(lookup (identifier x))]

given the environment;

@verbatim{
   e  = {(x,3), (y, 5)}
   e' = {(y,7), (z, 2)}
   e''  = e . e'
}

will give the output @racket[3].

@section[#:tag "lex:theory:exercises" #:style '(toc)]{Some Exercises}
@;ADD MORE
@bold{Exercise} Evaluate:

@racketblock[
(let ([x 3]) 
  (let ([y 5]) 
    (let ([x 4]) 
      (+ x y))))
]

@bold{Exercise} Find environment wherever 'x' is refered to

@racketblock[
(let ([x 3])
  (run (write x)
    (let([y 5])
    (run (write x)
      (let([x 4])
        (run (write x)
          (write (+ x y))))))))
]
