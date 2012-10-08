#lang scribble/doc

@(require scribble/manual
		scribble/bnf
		scribblings/scribble/utils
		(for-label scriblib/figure))

@title[#:tag "programming-2"]{Programming}

@bold{Recursive Programs on Lists}

@itemlist[#:style 'ordered
@item{
@bold{@emph{list-length}}

@emph{Purpose:} Computes the length of a list

@emph{Signature:} 
@defproc[(list-length  [ls list?])  nat?]

@emph{Implementation:}

@racketblock[
(define list-length
 (lambda (ls)
  (cond
   [(null? ls) 0]
   [else (+ 1
	   (list-length (rest ls)))])))

(list-length '())
(list-length '(a b c))
]
}
@item{

@bold{@emph{list-sum}}

@emph{Purpose:} Sums all the numbers in a list

@emph{Signature:} 
@defproc[(list-sum [ls list?])  nat?]

@emph{Implementation:}

@racketblock[
(define list-sum
 (lambda (ls)
  (cond
   [(null? ls) 0]
   [else (+
	   (first ls)
	   (list-sum (rest ls)))])))

(list-sum '())
(list-sum '(1))
(list-sum '(1 2 3))
]
}
]
