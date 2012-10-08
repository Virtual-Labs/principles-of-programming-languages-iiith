#lang scribble/doc

@(require scribble/manual
		scribble/bnf
		scribblings/scribble/utils
		(for-label scriblib/figure))

@title[#:tag "procedure-3"]{Procedure}

@bold{@emph{list-reduce:}}

list-reduce : [A, [(B, A) -> A]] -> [(listof B) -> A]

The type of @emph{list-reduce} is expressed in terms of type variables A and B.

@racketblock[
	(define list-reduce
	 (lambda (seed bop)
	  (lambda (ls)
	   (cond
	    [(null? ls) seed]
	    [else (bop
		    (first ls) 
		    ((list-reduce seed bop)
		     (rest ls)))]))))

]

Lets look at another version of @emph{list-reduce}, which uses an auxiliary local function @emph{f} which takes as parameters - only those that actually vary across calls @emph{(ls - in this case)}. This is a cleaner and neater way of writing recursive programs.

@racketblock[
	(define list-reduce
	 (lambda (seed bop)
	  (letrec ([f (lambda (ls)
		       (cond
			[(null? ls) seed]
			[else (bop
				(first ls)
				(f (rest ls)))]))])
	   f)))
]


@emph{Using @bold{list-reduce} to generate functions: }

@defproc[(list-length [ls list?]) number?]

@racketblock[
(define list-length
   (list-reduce 0
        (lambda (a ir)
	       (+ 1 ir))))
]

@bold{@emph{list-map:}}

The @emph{list-map} function takes a function @emph{f} and a list @emph{ls} and returns a new list whose each element is the result of applying @emph{f} to the corresponding element of @emph{ls}.

Formally speaking:

@racket[(length (list-map f ls))] = @racket[(length ls)]
	
	AND

@racket[(list-ref (list-map f ls) i)] = @racket[(f  (list-ref ls i))],  for 0<=i<=(length ls)

list-map : [(A -> B) , (listof A)] -> (listof B)

@racketblock[
	(define list-map
	 (lambda (f ls)
	  (cond
	   [(null? ls) '()]
	   [else
	   (cons (f (first ls))
	    (list-map f (rest ls)))])))
]
