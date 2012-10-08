#lang scribble/doc

@(require scribble/manual
		scribble/bnf
		scribblings/scribble/utils
		(for-label scriblib/figure))

@title[#:tag "quiz-2"]{Quiz}

@itemlist[#:style 'ordered
@item{
	Formally prove using induction that, the accumulator based implementation of factorial @racket[!/a] is correct.
}
@item{
	Write a recursive program to calculate the product of all the numbers in a list:
	@itemlist[#:style 'ordered
	@item{without using accumulators}
	@item{using accumulators}
	]
}
]
