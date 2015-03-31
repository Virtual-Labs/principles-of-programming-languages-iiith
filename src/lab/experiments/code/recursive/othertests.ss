;;; (recursive ([even? (n) (if (0? n) #t (odd? (- n 1)))]
;;;             [odd?  (n) (if (0? n) #f (even? (- n 1)))])
;;;    (even? 3))

(check-equal?
 (run
  (recursive
   (list
    (make-fbind 'even?
                '(n)
                (ifte (app (id-ref '0?) (list (id-ref 'n)))
                      (number '9)
                      (app (id-ref 'odd?)
                           (list (app (id-ref '-) (list (id-ref 'n) (number 1)))))))

    (make-fbind 'odd?
                '(n)
                (ifte (app (id-ref '0?) (list (id-ref 'n)))
                      (number '8)
                      (app (id-ref 'even?)
                           (list (app (id-ref '-) (list (id-ref 'n) (number 1))))))))
   
   (app (id-ref 'even?) (list (number 3)))))
  #f
  "run-recursive-test")


(check-equal?
  (go '(recursive ([f (n) (ifte (0? n) 1 (* n (f (- n 1))))])
         (f 3)))
  6
  "go-factorial")



(check-equal?
  (go
    '(recursive ([even? (n) (ifte (0? n) #t (odd? (- n 1)))]
                 [odd?  (n) (ifte (0? n) #f (even? (- n 1)))])
       (even? 3)))
  #f
  "go-even")
