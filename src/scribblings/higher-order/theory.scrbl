#lang scribble/doc

@(require scribble/manual
		scribble/bnf
		scribblings/scribble/utils
		(for-label scriblib/figure))

@title[#:tag "theory-3"]{Theory}

What exactly do we mean by @emph{order of functions}?

The order of data:
	@itemlist[
	@item{Order 0 : Non function data}
	@item{Order 1 : Functions with domain and range of order 0}
	@item{Order 2 : Functions with domain and range of order 1}
	@item{Order k : Functions with domain and range of order k-1}
	]

With the above understanding, we can now define higher-order functions to be - @bold{@emph{Functions of order i, i>=2}}.

A @bold{@emph{higher-order function}} :
	@itemlist[
	@item{takes one or more functions as input, and}
	@item{outputs a function}
	]

A typical example of this would be @emph{composite} functions - i.e. if @emph{f} and @emph{g} are two functions then @emph{fog} is the composite function defined as @emph{fog(x) = f(g(x))}.

Often, while using inductive datatypes, we end up building them in a recursive nature (yet not explicitly recursive, the constructor acts upon an instance of a certain type to return one of the same type). Many a times, our opperations on such instances require us to traverse the datatype. This traversal can have multiple uses in practice, yet the traversal is still of the same type. Hence, it makes sense to try and use a higher order function for the traversal which will take as an argument, the operation that is required to be done. As is seen, higher order functions are an integral part of inductive datatypes.
