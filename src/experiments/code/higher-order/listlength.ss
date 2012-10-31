#lang racket

(require eopl/eopl)

(require "list-reduce.ss")

(provide list-length)

;;; Implementation
  (define list-length
     (list-reduce 0
          (lambda (a ir)
                 (+ 1 ir))))