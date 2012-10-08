#lang racket

;;; =================
;;; Semantic Domains
;;; =================


;;; Expressible Values (types of values returned by
;;; evaluating an ast)

;;; ========================================

;;; expressible-value ::=
;;;    number | boolean | proc

;;; Denotable Values (types of values denoted by
;;; identifiers)
;;; ============================================

;;; denotable-value ::=
;;;  number | boolean | proc

(provide
  expressible-value?
  denotable-value?
  )

;;; expressible-value? is the set of things that are the
;;; results of evaluation of expressions (asts).


(require eopl/eopl)
(require "env-rec.ss")

;;; expressible-value? : any/c -> boolean?
(define expressible-value?
  (or/c number? boolean? proc?))

;;; denotable-value? :any/c -> boolean?
(define denotable-value?
  (or/c number? boolean? proc?))



