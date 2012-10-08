#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
          (for-label scriblib/figure))
@title[#:tag "theory-8"]{Theory}

@local-table-of-contents[]

Most high-level computer programming languages support recursion by
allowing a function to call itself within the program text. Some
functional programming languages do not define any looping constructs
but rely solely on recursion to repeatedly call code. Computability
theory has proven that these recursive-only languages are
mathematically equivalent to the imperative languages, meaning they
can solve the same kinds of problems even without the typical control
structures like 'while' and 'for'.

Building a Language with Recursive Functions will require again the
following four steps:

@section[#:tag "letrec:theory:abstractsyntax" #:style '(toc)]{Abstract Syntax}

Similar to the previous languages, we decide to use a list based
abstract syntax for representing procedures.

@racketblock[
(recursive ([even? (n) (if (0? n) #t (odd? (sub1 n)))]
             [odd?  (n) (if (0? n) #f (even? (sub1 n)))])
     (even? 5))
]

@section[#:tag "letrec:theory:evaluation" #:style '(toc)]{Evaluation}

The @emph{evaluator} is responsible for evaluating the abstract-syntax
tree produced by the parser in order to come up with the output of the
input program sequence.

For example: for the following scheme expression;

@racketblock[
(recursive ([even? (n) (if (0? n) #t (odd? (sub1 n)))]
             [odd?  (n) (if (0? n) #f (even? (sub1 n)))])
     (even? 5))
]

will create an recursive environment with bindings for @emph{even?}
and @emph{odd?} and will give the following output:

@racket[(#f boolean)]

@section[#:tag "letrec:theory:unparsing" #:style '(toc)]{Unparsing}

This is the exact same as described previously.

@racket[(#t boolean) ---> #t]

@section[#:tag "clo:theory:exercises" #:style '(toc)]{Some Exercises}
@;ADD MORE
@bold{Exercise} Evaluate:

@racketblock[
(recursive ([f (n) (ifte (0? n) 1 (* n (f (- n 1))))])
         (f 3))
]
