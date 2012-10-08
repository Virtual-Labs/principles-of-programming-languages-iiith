#lang scribble/manual
@title[#:tag "introduction" #:style '(toc)]{Introduction}
@local-table-of-contents[]

@section{Objective of the PoPL lab}

The Principles of Programming virtual laboratory is a
platform for students to understand the principles behind
how languages are designed and implemented, and how programs
in a programming language run.

@section{Approach taken by the PoPL lab}

We understand programming languages and the machinery of
program execution by building a series of small languages
and their interpreters.  An @emph{interpreter} is a program
that takes a program in another (or possibly the same)
programming language as input and evaluates it to
return an answer.  An interpreter may be thought of as a
@emph{virtual machine}, with its own components and rules of
execution.

The exercise of designing and implementing complete,
runnable interpreters unravels the machinery needed for
proper program representation, execution and analysis.  The
experiments in this lab guide the student systematically
through the process of building interpreters.

@section{Pre and co-requisites}

@bold{@emph{Background in Scheme programming}}:
The student should be proficient in  Scheme
programming and, ideally studied the book
@emph{How to Design Programs} available at
@(let [(url "http://www.htdp.org/")]
		(link url url))


@bold{@emph{Scheme/Racket programming
environment}}: Ideally, the student should have
used the Racket programming environment.  Racket
is a dialect of Scheme, and is documented at
@(let [(url
"http://docs.racket-lang.org/guide/index.html")]
(link url url))

@bold{@emph{Course in Principles of Programming}}: The lab
assumes that the student has either already taken or is currently
taking a course on the Principles of Programming, ideally
using the text @emph{Essentials of Programming Languages,
3rd Edition, Friedman and Wand} (EoPL).  EoPL teaches the
essentials of programming language by building interpreters
for a succession of small languages.  One may use the
material in this virtual laboratory to 
supplement EoPL.


@section{Structure of each experiment}

The lab is divided into experiments.  Each
experiment explores a concept or a mini-language
in systematic way.  The experiment is divided
into the following sections:

@itemlist[

@item{@emph{Objective} : This section identifies the goal of
the experiment, which is to explore a concept by
implementing it in Scheme code.}

@item{@emph{Theory} : This section provides the necessary
theoretical background to support the implementation of the
concept.  The section uses examples to illustrate the
concept.}

@item{@emph{Procedure} : This section outlines a systematic
process divided into steps to design and build
implementation of the concept.  This section uses the
example(s) introduced in the theory section and builds on them.}

@item{@emph{Programming} : Puts together a complete running
program obtained as a result of integrating all the steps
shown in the procedure section.}

@item{@emph{Quiz} : Sample theory and programming questions
for testing the student's understanding.}

@item{@emph{Further-Reading} : References, further-reading, etc.}
]

@section{List of all Experiments}

@itemlist[#:style 'ordered

@item{@seclink["inductive-data"]{Designing Inductive Data}}
@item{@seclink["recursion"]{Programming with Inductive Data}}
@item{@seclink["higher-order"]{Higher Order Functions}}
@item{@seclink["arithmetic"]{ARITHMETIC: A Language for Arithmetic}}
@item{@seclink["environments"]{ENVIRONMENT: Abstract Data Type for Lexical Environment}}
@item{@seclink["lexical"]{LEXICAL:    A Language with Block Structure}}
@item{@seclink["closure"]{CLOSURE:   A Language with First class functions}}
@item{@seclink["letrec"]{LETREC: A Language with Recursive functions}}
@item{@seclink["objects"]{OBJECTS: A Language for Object-oriented programming}}

]

@section{Instructions for UI}

@subsection{Regular Scheme code}
You can write your regular scheme code, just like you do in drracket UI. 

Once done writing, press "SHIFT+ENTER" to execute it.

Make sure that by default eopl (Essentials of Programming Languages)
will be the chosen language. If you want to switch to htdp (How to
Design Programs), you should execute the following command in the
provided terminal on the lab-page:

(require lang/<choose one from the below options>)

1. htdp-beginner
2. htdp-beginner-abbr
3. htdp-intermediate
4. htdp-intermediate-lambda
5. htdp-advanced 

by writing in the window and then pressing "SHIFT+ENTER" to execute it
in the regular way.

NOTE: We recommend you to use the htdp-advanced while working with the experiments.

@subsection{Importing Modules/Files}
In order to import external files and use them as modules, first make sure that your file is a top level module - i.e. it should have a @defmodulelang[racket] ...(or other such similar definitions) in the beginning.

Also, export the required functions using @racket[provide]

Upload the file, using the File-Upload interface.

Import the uploaded file using @racket[(require filename.ss)].
