;;; Recursive version of factorial
(define !
  (lambda (n)
    (letrec ([f (lambda (n)
                  (if (= n 0)
                      1
                    (* n (f (- n 1)))))])
      (f n))))


;;; Tail Recursive version of factorial
(define !/a
  (lambda (n)
    (letrec ([f (lambda (n a)
                  (if (= n 0)
                      a
                      (f (- n 1) (* a n))))])
      (f n 1))))


;;; Factorial with explicit vars
(define !/explicit-vars
  (function (n)
    (assume ([m (ref n)]
             [a (ref 1)])
      (recursive
       ([loop ()
          (ifte (eq? (deref m) 0)
            (deref a)
            (seq
              (setref a
                (* (deref a) (deref m)))
              (setref m (- (deref m) 1))
              (loop)))])
       (loop)))))


;;; Factorial with Implicit vars
(define !/implicit-var
  (lambda (n)
    (let ([m n]
          [a 1])
      (letrec
        ([loop
           (lambda ()
             (if (= m 0)
               a
               (begin
                 (set! a (*  a m))
                 (set! m (-  m 1))
                 (loop))))])
        (loop)))))


;;; Register machine version
(define !/reg
  (lambda (n)
    (let ([m n]
          [a 1])
      (letrec
        ([loop
           (lambda ()
             (if (= m 0)
               a
               (begin
                 (set! a (*  a m))
                 (set! m (-  m 1))
                 (goto loop))))])
        (goto loop)))))

(define goto
  (lambda (f)
    (f)))



   
       




