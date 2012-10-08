;;; ===================================
;;; list represenation of continuations
;;; ===================================


;;; continuation constructors
;;; =========================


;;; k? = list?

;;; (define k? list?)


(define top-k
  (lambda ()
    (let ([k '(top-k)])
      (printf "building k = ~a~n" k)
      k)))

(define fact1-k
  (lambda (n saved-k)
    (let ([k `(fact1-k ,n ,saved-k)])
      (printf "building k = ~a~n" k)
      k)))

(define apply-k
  (lambda (c v)
    (printf "applying K = ~a~n to V =~a~n" c v)
    (match c
      [(list 'top-k)
       (printf "Ans: ~a~n" v)]
      [(list 'fact1-k val saved-k)
       (apply-k saved-k (* val v))]
      [_ (error 'apply-k "incorrect continuation ~a" c)])))


;;; no change to fact/k
(define fact/k
  (lambda (n k)
    (if
      (zero? n)
      (apply-k k 1)
      (fact/k (- n 1)
        (fact1-k n k)))))

;;; no change
(define fact
  (lambda (n)
    (fact/k n (top-k))))











