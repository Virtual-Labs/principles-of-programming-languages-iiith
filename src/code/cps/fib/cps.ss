(define fib/k
  (lambda (n k)
    (cond
      [(= n 0) (k 0)]
      [(= n 1) (k 1)]
      [else
        (fib/k (sub1 n)
          (lambda (n1)
            (fib/k (sub2 n)
              (lambda (n2)
                (k (+ n1 n2))))))])))

(define sub2
  (lambda (n)
    (- n 2)))

