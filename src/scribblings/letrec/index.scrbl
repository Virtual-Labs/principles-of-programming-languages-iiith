#lang scribble/doc

@(require scribble/manual
          scribble/bnf
          scribblings/scribble/utils
	  scribblings/guide/modfile
          (for-label scriblib/figure))

@title[#:tag "letrec" #:style '(toc)]{LETREC: A Language with Recursive functions}

@local-table-of-contents[]

  @include-section["objective.scrbl"]
  @include-section["theory.scrbl"]
  @include-section["procedure.scrbl"]
  @include-section["programming.scrbl"]
  @include-section["quiz.scrbl"]
  @include-section["further-reading.scrbl"]
  @include-section["feedback.scrbl"]
