(define fib
  (lambda (n)
    (cond
      [(= n 0) 0]
      [(= n 1) 1]
      [else (+ (fib (sub1 n))
               (fib (sub2 n)))])))

(define sub2
  (lambda (n)
    (- n 2)))