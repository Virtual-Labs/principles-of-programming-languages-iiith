#lang scribble/doc

@(require scribble/manual
		scribble/bnf
		scribblings/scribble/utils
		(for-label scriblib/figure))

@title[#:tag "programming-3"]{Programming}

@itemlist[#:style 'ordered

@item{@bold{@emph{filter:}}

@emph{filter} takes a predicate @emph{pred?} on elements of type A and a list @emph{ls} of elements of type A, and returns another list of elements from @emph{ls} that satisfy @emph{pred?}.

filter : [(A -> boolean?), (listof A)] -> (listof A)

@racketblock[
	(define filter
	 (lambda (pred? ls)
	  (cond
	   [(null? ls) '()]
	   [(pred? (first ls))
	   (cons (first ls)
	    (filter pred? (rest ls)))]
	   [else (filter pred? (rest ls))])))
]
}

@item{@bold{@emph{count:}}

@emph{count} takes a predicate @emph{pred} and a list @emph{ls} and returns the number of elements in @emph{ls} that satisfy @emph{pred?}.

count : [(A -> boolean?), (listof A)] -> number?

@racketblock[
(define count
   (lambda (pred? ls)
        (length (filter pred? ls))))
]
}
]
