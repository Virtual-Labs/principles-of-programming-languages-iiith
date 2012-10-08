#lang scribble/doc
@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "programming-1"]{Programming}


@#reader scribble/comment-reader
  (defexamples

   ;;;; Designing an implementation of the nat? datatype
   ;;;;
   ;;;; Step 1: Naming of inductive type and corresponding type  predicate
   ;;;; ==================================================================
   ;;;; The inductive type of natural numbers is denoted nat and
   ;;;; represented by the type predicate nat?
   ;;;; nat? : TYPE 
   ;;;;
   ;;;; Step 2: Defining subtype predicates and constructor signatures
   ;;;; ==============================================================
   ;;;; z? : SUBTYPE  of nat?
   ;;;; s? : SUBTYPE  of nat?
   ;;;; z: () -> z?
   ;;;; s: nat? -> s?
   ;;;;
   ;;;; Step 3: Defining extractor signatures
   ;;;; =====================================
   ;;;; s-pred: s? -> nat?
   ;;;;
   ;;;; Step 4: Choosing a representation for nat
   ;;;; =========================================
   ;;;; Use a list of n a's to denote the natural n.
   ;;;;
   ;;;; Step 5: Implementation of constructors and extractors
   ;;;; =====================================================
   ;;;; 
   ;;;; z : () -> z?
   (define z
      (lambda ()
        '()))

   ;;;; s : nat? -> s?
   (define s
      (lambda (n)
         (cons 'a n)))

   ;;;; s-pred : s? -> nat?
   (define s-pred 
      (lambda(n)
	 (cdr n)))

   
   ;;;; Examples
   ;;;; ========


   ;;;; Representing 0
   (z)

   ;;;; Representing 3
   (s (s (s (z))))

   ;;;; Predecessor of 3
   (s-pred (s (s (s (z)))))
)


