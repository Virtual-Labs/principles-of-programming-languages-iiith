(define list-map
  (lambda (h ls)
    (cond
     [(null? ls) '()]
     [else (cons (h (first ls)) (list-map h (rest ls)))])))