;;; factorial with continuations:

;;; k? : number? -> answer?
;;; answer? = void?    
;;;
;;; fact/k : [number? k?] -> answer?
(define fact/k
  (lambda (n k)
    (if
      (zero? n)
      (k 1)
      (fact/k (sub1 n)
        (lambda (v)
          (k (* n v)))))))

;;; top-k : k?
(define top-k
  (lambda (v)
    (printf "~a" v)))

;;; number? -> answer?
(define fact
  (lambda (n)
    (fact/k n top-k)))








