#lang scribble/doc

@(require scribble/manual
		scribble/bnf
		scribblings/scribble/utils
		(for-label scriblib/figure))

@title[#:tag "theory-2"]{Theory}

The structure of inductive datatypes lends itself to an
elegant way of writing programs that operate on inductive
data.  These programs @italic{call} themselves recursively
(i.e, call by referring to themselves) on the substructures
of the inductive datatype, but not on the base cases of the
inductive type.  The key point to note is that the structure
of the recursive programs parallels the structure of the
inductive type.


Recursive programs on inductive types map inductive data to
values in a result set (an @emph{algebra} when we consider
the operations on the set as well). 
 
For e.g.

@bold{@emph{list:}}

@itemlist[
@item{@racket[()] : empty list}

@item{@racket[(cons x ls)] :
	@itemlist[
		@item{@emph{x} is any scheme value}
		@item{@emph{ls} is a list - where the definition of list is, again :
			@itemlist[
				@item{@racket[()] : empty list}
				@item{@racket[(cons y ls1)] : 
				@itemlist[
				@item{@emph{y} is any scheme value}
				@item{@emph{ls1} is a list 

				... and so on
				}
				]
				}
			]
		}
]
}
]

@emph{Example Code:}

@racketblock[

(define natural?
  (lambda (thing)
    (or (base-case? thing)
	(constructor-1? thing)
	(constructor-2? thing))))

(define (base-case? thing)
  (eq? thing 'z))


(define (succ? thing)
  (and 
   (list? thing)
   (= (length thing) 2)
   (eq? (head thing) 's)
   (natural? (second thing))))
]


@racketblock[
(define (nonempty-left nbt)
  (and 
   (list? thing)
   (= (length thing) 2)
   (eq? (head thing) 's)
   (natural? (second thing))))
]

