#lang scheme

;;; ======================================================
;;; Vector implementation of the Store Abstract Data Type
;;; ======================================================


;;; A store is implemented as a triple.  The first element
;;; is the symbol 'store'.  The second is a vector vec.  The
;;; third is a natural number n that denotes the next free
;;; location in the vector.
;;; Invariant: n <= (vector-length vec).

(require racket/match)

(provide
  store?
  ref?
  new-store
  new-ref
  deref
  setref
  )
 
;;; nat? : any/c -> boolean?
(define nat?
  (lambda (n)
    (and (integer? n)
         (>= n 0))))

;;; store? : any/c -> boolean?
(define store?
  (lambda (thing)
    (match thing
      [(list 'store (? vector? vec)  (? nat? n))
       (<= n  n (vector-length vec))]
      [_ #f])))

;;; make-store : [v : vector?  n: nat?] -> store?
;;; pre-condition: (within-limits? n v)
(define make-store
  (lambda (v n)
    (list 'store v n)))

;;; new-store : () -> store?
(define new-store
  (lambda ()
    (make-store (make-vector 8) 0)))

;;; store-length returns the number of locations occupied in the store, which
;;; is also the next "free" location.
;;; store-length : store? -> nat?
(define store-length
  (lambda (store)
    (match-let ([(list _  _ n) store])
      n)))

;;; store-vector : store? -> vector
(define store-vector
  (lambda (store)
    (match-let ([(list _ v _) store])
      v)))

;;; ref?  : any/c -> boolean?
(define ref? nat?)

;;; storable-value? : any/c -> boolean?
(define storable-value? any/c)

;;;  deref: [store?  ref?] -> storable-value?
;;;  deref: "throws address out of bounds" error
(define deref
  (lambda (s r)
    (cond
     [(< r (store-length s))
      (vector-ref (store-vector s) r)]
     [else (error 'deref "address out of bounds: ~a" r)])))

;;;  setref: [store?  ref? storable-value?] -> store?
;;;  setref: "throws address out of bounds" error if r out of s's bounds.
(define setref
  (lambda (s r v)
    (let ([vec (store-vector s)])
      (cond
        [(< r (store-length s))
         (vector-set! vec r v)  s]
        [else (error 'deref "address out of bounds: ~a" r)]))))

;;;  new-ref: [store?  storable-value?] -> [store? ref?]
(define new-ref
  (lambda (s v)
    (let ([full? (store-full? s)])
      (let* ([vec (store-vector s)]
             [n (store-length s)]
             [vec (if full?
                      (let ([new-vec (make-vector (* 2 n))]) ; double new storage
                        (vector-copy! vec new-vec) ; copy into new-vec
                        new-vec)
                    vec)])
        (vector-set! vec n v)
        (list (make-store vec (+ n 1)) n)))))

;;; store-full? : store?  -> boolean?
(define store-full?
  (lambda (s)
    (match s
      [(list 'store v n)    ; switch the positions of n and v and Racket CRASHES!
       (= n (vector-length v))])))


(require rackunit)

(define-simple-check (check-store? thing)
  (store? thing))

;;; implementation tests
;;; --------------------
(check-store? (new-store))
(check-store? (make-store (make-vector 5) 2))
(check-store? (make-store (make-vector 5) 5))
(check-store? (make-store (make-vector 1) 0))

(check-equal? (store-length (make-store (make-vector 3) 2)) 2)
(check-equal? (store-vector (make-store (make-vector 3) 2)) (make-vector 3))


;;; API tests
;;; ---------
(define s0 (new-store))
(define ans (new-ref s0 'a))
(define s1 (match-let ([(list s _) ans]) s))
(define r1 (match-let ([(list _ r) ans]) r))

(check-equal? r1 0)
(check-equal? (deref s1 0) 'a)
(check-exn exn? (lambda ()
                  (deref s1 1)))

(define s2 (setref s1 0 'b))
(check-equal? (deref s2 0) 'b)
(check-exn exn? (lambda () (setref s2 3 'c)))




                     




                







  