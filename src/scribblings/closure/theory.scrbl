#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))
@title[#:tag "theory-7"]{Theory}

@local-table-of-contents[]

A first-class object is an entity that can be passed as a parameter,
assigned to a variable, or returned from a subroutine. Such first
class objects can be constructed at runtime. Treating functions as
first class objects is a necessity for functional programming,
particularly in higher order functions. Higher order functions are
those functions which either take one or more functions as input or
output a function. These are also known as @emph{operators} or
@emph{functionals} in mathematics. Thus, functions are now denotable
values.


Building a Language with Closures will require again the following four steps:

@section[#:tag "clo:theory:abstractsyntax" #:style '(toc)]{Abstract Syntax}

Similar to the previous languages, we decide to use a list based abstract syntax for representing procedures.

@racket[(function ((identifier x) (identifier y)) exp)]

This represents a procedure which takes two arguments x and y and evaluates an expression in its body.

@section[#:tag "clo:theory:parsing" #:style '(toc)]{Parsing}

This converts the input sequence (in concrete syntax) into abstract syntax tree representation.

@section[#:tag "clo:theory:evaluation" #:style '(toc)]{Evaluation}

The @emph{evaluator} is responsible for evaluating the abstract syntax tree produced by the parser 
to come up with the output of the input program sequence.

For example: for the following scheme expression;

@racket[(function ((identifier x) (identifier y)) (app x y))]

given the environment;

@verbatim{
   e  = {(x,((var) (add1 var))), (y, 5)}
}

will give the following output:

@racket[6]


@section[#:tag "clo:theory:exercises" #:style '(toc)]{Some Exercises}
@;ADD MORE
@bold{Exercise} Evaluate:

@racketblock[
(let ([x 3]) 
  (let ([y (function (x) (* x 5))]) 
    (let ([x 4]) 
      (app y x))))
]
