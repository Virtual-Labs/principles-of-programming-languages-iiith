(define *unitialized* '_)

;;; n holds the first component of the fact1-k continuation
(define n *unitialized*)
;;; k holds the current continuation
(define k *unitialized*)

;;; result holds the intermediate result of computation
(define result *unitialized*)

(define fact
  (lambda (m)
    (set! k (top-k))
    (set! n m)
    (fact/k)))


(define  fact/k
  (lambda ()
    (if (zero? n)
      (begin
        (set! result 1)
        (apply-k))
      (begin
        (set! k (fact1-k n k))
        (set! n (sub1 n))
        (fact/k)))))


(define top-k
  (lambda ()
    '(top-k)))
  
(define fact1-k
  (lambda (n k)
    (list 'fact1-k n k)))


(define apply-k
  (lambda ()
    (match k
      [(list 'top-k)
       (printf "Ans: ~a~n" result)]
      [(list 'fact1-k saved-n saved-k)
       (set! k saved-k)
       (set! result (* saved-n result))
       (apply-k)]
      [_ (error 'apply-k "incorrect continuation ~a" k)])))




      
              
    
