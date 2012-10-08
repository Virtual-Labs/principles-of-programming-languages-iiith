#lang scribble/doc

@(require scribble/manual
          scribble/bnf
	  scribble/eval
          scribblings/scribble/utils
          (for-label scriblib/figure))

@title[#:tag "programming-5"]{Programming}


@bold{lookup-env} 

@emph{Purpose:} Takes an environment and an identifier and
retrieves the denotable value to which the identifier is
bound.  Raises an "identifier not bound" error if the given
environment does not contain the identifier.

@emph{Signature:} 
@defproc[(lookup-env [id symbol?] [env env?]) denotable-value?]

@emph{Implementation:}


@racketblock[
(provide
  env
  env?
  empty-env
  extended-env
  lookup-env)

(require eopl/eopl)

(define-datatype env env?
  [empty-env]
  [extended-env
    (syms (list-of symbol?))
    (vals (list-of any/c))
    (outer-env env?)])

(define empty-env?
  (lambda (e)
    (cases env e
      [empty-env () #t]
      [else #f])))

(define extended-env?
  (lambda (e)
    (cases env e
      [empty-env () #f]
      [else #t])))

(define list-index
  (lambda (ls a)
    (letrec ([loop
               (lambda (ls ans)
                 (cond
                   [(null? ls) -1]
                   [(eq? (first ls) a) ans]
                   [#t (loop (rest ls) (+ 1 ans))]))])
      (loop ls 0))))

(define lookup-env
  (lambda (e x)
    (cases env e
      [empty-env ()
        (error
          'lookup-env
          "unbound identifier ~a" x)]
      [extended-env (syms vals outer-env)
        (let ([j (list-index syms x)])
          (cond
            [(= j -1) (lookup-env outer-env x)]
            [#t (list-ref vals j)]))])))
]
