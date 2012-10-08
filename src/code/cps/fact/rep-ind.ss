;;; ==========================================
;;; Factorial with representation independence
;;; ==========================================


;;; continuation constructors
;;; =========================

;;; top-k : () -> k?
(define top-k
  (lambda ()
    (lambda (v)
      (printf "~a" v))))

;;; fact1-k : [number? k?] -> k?
(define fact1-k
  (lambda (n k)
    (lambda (v)
      (apply-k k (* n v)))))


;;; continuation application
;;; apply-k : [k?  number?] -> answer?
(define apply-k
  (lambda (k v)
    (k v)))

;;; fact/k : [number? k?] -> answer?
(define fact/k
  (lambda (n k)
    (if
      (zero? n)
      (apply-k k 1)
      (fact/k (sub1 n)
        (fact1-k n k)))))

;;; fact : number? -> answer?
(define fact
  (lambda (n)
    (fact/k n (top-k))))








