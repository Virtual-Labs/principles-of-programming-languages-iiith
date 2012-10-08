;;; ==============================================
;;; define-datatype represenation of continuations
;;; ===============================================


;;; continuation constructors
;;; =========================

(require eopl/eopl)

(define-datatype k  k?
  [top-k]
  [fact1-k (val number?) (saved-k k?)])

(define apply-k
  (lambda (c v)
    (cases k c
      [top-k () 
        (printf "Ans: ~a~n" v)]
      [fact1-k (val saved-k)
        (apply-k saved-k (* val v))])))



;;; no change to these

(define fact/k
  (lambda (n k)
    (if
      (zero? n)
      (apply-k k 1)
      (fact/k (- n 1)
        (fact1-k n k)))))


(define fact
  (lambda (n)
    (fact/k n (top-k))))








