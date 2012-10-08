(define list-map/k
  (lambda (h/k ls k)
    (cond
      [(null? ls) (k '())]
      [else (h/k (first ls)
              (lambda (v)
                (list-map/k h/k (rest ls)
                  (lambda (m)
                    (k (cons v m))))))])))

(define add1/k
  (lambda (v k)
    (k (add1 v))))

