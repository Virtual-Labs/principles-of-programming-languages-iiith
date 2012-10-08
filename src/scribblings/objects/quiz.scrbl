#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "quiz-10"]{Quiz}

Implement a class @racket[point], for representing a two-dimensional
point as per the implementation details provided in the Programming
section.

The class should have the following methods:

@itemlist[#:style 'ordered
	@item{@racket[set] - for setting up the values of the coordinates.}
	@item{@racket[get] - for getting the values of the coordinates.}
	@item{@racket[dist] - for calculating the distance between the point and another point (which is passed as an argument).}
	@item{@racket[rotate] - for updating the coordinate values when the system is rotated about the origin by some specified angle.}
	@item{@racket[translate] - for updating the coordinate values when the system is translated to anothe point.}
]

For testing, execute the following code (in the scheme window beside) to obtain the test results:

@racketblock[
(require "test/test-objects.ss")
(test-objects)
]
