(define *unitialized* '_)

;;; n holds the first component of the fact1-k continuation
(define n *unitialized*)
;;; k holds the current continuation
(define k *unitialized*)

;;; result holds the intermediate result of computation
(define result *unitialized*)

;;; pc holds the next point of execution
(define pc *unitialized*)

(define next
  (lambda ()
    (if pc
      (begin
        (pc)
        (show))
      (printf "Computation finished~n"))))


(define show
  (lambda ()
    (printf "n: ~a~n" n)
    (printf "k: ~a~n" k)
    (printf "pc: ~a~n" pc)
    (printf "result: ~a~n" result)
    (printf (if pc "~n" "Computation finished~n"))))


(define init
  (lambda (m)
    (set! k (top-k))
    (set! n m)
    (set! pc fact/k)
    (set! result *unitialized*)))

(define fact
  (lambda (m)
    (init m)
    (trampoline!)))


(define  fact/k
  (lambda ()
    (if (zero? n)
      (begin
        (set! result 1)
        (set! pc apply-k))
      (begin
        (set! k (fact1-k n k))
        (set! n (sub1 n))
        (set! pc fact/k)))))


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
       (printf "Ans: ~a~n" result)
       (set! pc #f)]
      [(list 'fact1-k saved-n saved-k)
       (set! k saved-k)
       (set! result (* saved-n result))
       (set! pc apply-k)]
      [_ (error 'apply-k "incorrect continuation ~a" k)])))


(define trampoline!
  (lambda ()
    (if pc
      (begin
        (pc)
        (trampoline!))
      'done)))
      
      



      
              
    
