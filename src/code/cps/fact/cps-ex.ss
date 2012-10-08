;;; Motivation for CPS
;;; -------------------



;;; Contexts
;;; ========


;;; A context of a subcomputation with respect to a a
;;; computation is the rest of the computation that is left
;;; to do after the subcomputation computes its result.

;;; For simple programs

(define g
  (lambda (x)
    (+ x 2)))



(* 3 (g 4))

(* 3 (+ 4 2))

(define k
  (lambda (v)
    (* 3 v)))


(k (+ 4 2))

(k (g 4))

Now, consider a different function

(define g/k
  (lambda (x k)
    (k (+ x 2))))


Prove:

(g/k n k) = (k (g n))

Proof:

lhs = (g/k n k) = (k (+ n 2))
rhs = (k (g n)) = (k (+ n 2))

g/k carries with it its continuation k.  k picks up the
result evaluated by g.  





