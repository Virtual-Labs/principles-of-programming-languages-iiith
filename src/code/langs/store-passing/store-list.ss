#lang scheme
;;; ==============================
;;; List implementation of Stores
;;; ==============================

;;; A store is implemented as a list.

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

(define ref? nat?)

(define storable-value? any/c)


;;; store? : any/c -> boolean?
(define store? list?)


;;; new-store : () -> store?
(define new-store
  (lambda ()
    '()))

;;; store-length : store? -> nat?
(define store-length length)

;;; new-ref: [store? storable-value?] -> [store? ref?]
(define new-ref
  (lambda (s v)
    (list (cons v s) (store-length s))))

;;;  deref: [store?  ref?] -> storable-value?
;;;  deref: "throws address out of bounds" error
(define deref
  (lambda (s r)
    (let ([n (store-length s)])
      (cond
       [(< r n)
        (list-ref s (- n r 1))]
       [else (error 'deref "address outside of bounds: ~a" r)]))))

;;;  setref: [store?  ref? storable-value?] -> store?
;;;  setref: "throws address out of bounds" error if r out of s's bounds.
(define setref
  (lambda (s r v)
    (let ([n (store-length s)])
      (cond
       [(< r n) (replace s (- n r 1) v)]
       [else  (error 'deref "address outside of bounds: ~a" r)]))))

;;; replace
;;; -------
;;; construct a list like ls except that ls contains v at
;;; index i

;;; replace : ([ls : (listof any/c)]
;;;            [i : (</c (length ls))]
;;;            [v : any/c]) ->
;;;           (listof any/c)

(define replace
  (lambda (ls i v)
    (cond
     [(= i 0)
      (cons v (rest ls))]
     [else (cons (first ls)
                 (replace (rest ls)
                          (sub1 i)
                          v))])))

;;; unit Testing
;;; ============

;;; Racket's unit testing framework
(require rackunit)

;;; implementation tests
;;; --------------------

(define-simple-check (check-store? thing)
  (store? thing))

(check-store? (new-store))

(check-equal? (store-length (new-store)) 0 "test:store-length-empty-store")
(check-equal? (new-ref (new-store) 'a)  '((a) 0) "test:new-ref-empty-store")
(check-equal? (first (new-ref (new-store) 'a))  '(a) "test:new-ref^1")
(check-equal? (first (new-ref (first (new-ref (new-store) 'a)) 'b)) '(b a) "test:new-ref^2")
(check-equal? (first (new-ref (first (new-ref (first (new-ref (new-store) 'a)) 'b)) 'c))
              '(c b a) "test:new-ref^3")

(check-equal?
 (match-let ([(list s r) (new-ref (new-store) 4)])
    (new-ref s 8))
 '((8 4) 1))

(check-equal?
 (match-let ([(list s r1) (new-ref (new-store) 4)])
    (match-let ([(list s r2) (new-ref s 8)])
       (setref s r1 7)))
 '(8 7))


(check-equal?
  (match-let ([(list s r1) (new-ref (new-store) 4)])
    (match-let ([(list s r2) (new-ref s 8)])
       (setref s r2 15)))
  '(15 4))

(check-equal?
  (match-let ([(list s r1) (new-ref (new-store) 4)])
    (match-let ([(list s r2) (new-ref s 8)])
      (setref s r2 (+ (deref s r1) (deref s r2)))))
  '(12 4))


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


(check-equal?
  (match-let ([(list s r) (new-ref (new-store) 4)])
    (let ([s (setref s r 7)])
      (deref s r)))
  7)


(check-equal?
  (match-let ([(list s r) (new-ref (new-store) 4)])
    (match-let ([(list s r) (new-ref s 8)])
      (deref s 0)))
  4)

(check-equal?
  (match-let ([(list s r) (new-ref (new-store) 4)])
    (match-let ([(list s r) (new-ref s 8)])
      (deref s r)))
  8)


  



