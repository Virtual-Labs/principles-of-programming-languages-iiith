#lang scheme

;;; Direct and continuation passing style versions of preorder
;;; and preempted preorder traversals of binary trees.

(require eopl/eopl)

(provide
  tree
  tree?
  traverse-pre
  traverse-pre-k
  traverse-pre/reg
  visit-k
  visit-d
)
  
  

;;; Tree datatype
;;; -------------
(define-datatype tree tree?
  [leaf (val any/c)]
  [interior (val any/c) (left tree?) (right tree?)])


;;; Direct style preorder traversal
;;; ===============================

;;; answer
;;; ------
;;; answer? : TYPE = (listof any/c)


;;; traverse-pre : tree? -> answer?
(define traverse-pre
  (lambda (t)
    (cases tree t
      [leaf (val) (list val)]
      [interior (val left right)
        (append (cons val (traverse-pre left)) (traverse-pre right))])))


;;; Preorder traversal in cps
;;; =========================

;;; K? = answer? -> answer?

;;; traverse-pre/k : [tree?  K?] -> answer?
(define traverse-pre/k
  (lambda (t k)
    (cases tree t
      [leaf (val) (k (list val))]
      [interior (val left right)
        (traverse-pre/k left
          (lambda (l)
            (traverse-pre/k right
              (lambda (r)
                (append/k (cons val l) r k)))))])))

;;; append/k : [answer? answer? K?] -> answer?
(define append/k
  (lambda (l1 l2 k)
    (cond
     [(null? l1) (k l2)]
     [#t (append/k (rest l1) l2
           (lambda (l)
             (k (cons (first l1) l))))])))



;;; topk-k : any/c -> any/c
(define top-k
  (lambda (v) v))

;;; traverse-pre-k : tree? -> answer?
(define traverse-pre-k
  (lambda (t)
    (traverse-pre/k t top-k)))

;;; (Semi)-registerized, ie., imperative, version of
;;; pre-order traversal.  Note that the internal recursive
;;; function g does not return a value; instead it affects
;;; the variable ans.

;;; traverse-pre/reg : tree? -> answer?
(define traverse-pre/reg
  (lambda (t)
    (let ([ans '()]) ; ans stores the list of  visits so far
      (letrec ([g (lambda (t)
                    (cases tree t
                      [leaf (val)
                        (set! ans (append ans (list val)))]
                      [interior (val left right)
                        (set! ans (append ans (list val)))
                        (g left)
                        (g right)]))])
        (g t)
        ans))))


;;; Visit: preempted traversal
;;; ==========================

;;; A visit is a pre-order traversal of the tree that gets
;;; preempted as soon as the visit encounters a zero value.  


;;; (visit/k t f k) : (list any/c)
;;;   t : tree?
;;;   f : (listof any/c)
;;;   k : (listof any/c) -> (listof any/c)

(define visit/k
  (lambda (t f k)   ; t: tree (present)
                    ; f: list of values traversed so far (past)
                    ; k: continuation (future). takes list of values traversed so far
    (cases tree t
      [leaf (val)
        (if (zero? val)
          (top-k f)
          (k (append f (list val))))]

      [interior (val left right)
        (if (zero? val)
          (top-k f)
          (visit/k left (append f (list val))
            (lambda (lf)
              (visit/k right lf k))))])))

;;; visit-k : tree? -> answer?
(define visit-k
  (lambda (t)
    (visit/k t '() top-k)))


;;; Visit in direct-style
;;; =====================

;;; version of visit in direct style, using call/cc to
;;; capture the top-level continuation and using the store
;;; (memory) to remember the sequence of past visits.  

;;; visit-d : tree? -> (listof any/c)

(define visit-d
  (lambda (t)
    (call/cc
     (lambda (top-k)  ; continuation of the visit/c call.
       (let ([ans '()])  ; ans stores the list of  visits so far
         (letrec
           ([g
              (lambda (t)
                (cases tree t
                  [leaf (val)
                    (if (zero? val)
                      (top-k ans)  ; escape using  top-k
                      (set! ans (append ans (list val))))]
                  [interior (val left right)
                    (if (zero? val)
                      (top-k ans) ; escape using top-k
                      (begin
                        (set! ans (append ans (list val)))
                        (g left)  ; notice that this call to g is in non-tail position
                        (g right)))]))])
           (g t)
           ans))))))


(require rackunit)

(define t1 (interior 5 (leaf 4) (leaf 3)))
(define t2 (interior 6 (leaf 0) t1))
(define t3 (interior 0 (leaf 5) (leaf 8)))

(check-equal? (traverse-pre t1) '(5 4 3))
(check-equal? (traverse-pre t2) '(6 0 5 4 3))
(check-equal? (traverse-pre t3) '(0 5 8))


(check-equal? (traverse-pre-k t1) '(5 4 3))
(check-equal? (traverse-pre-k t2) '(6 0 5 4 3))
(check-equal? (traverse-pre-k t3) '(0 5 8))


(check-equal? (traverse-pre/reg t1) '(5 4 3))
(check-equal? (traverse-pre/reg t2) '(6 0 5 4 3))
(check-equal? (traverse-pre/reg t3) '(0 5 8))



(check-equal? (visit-k t1) '(5 4 3))
(check-equal? (visit-k t2) '(6))
(check-equal? (visit-k t3) '())


(check-equal? (visit-d t1) '(5 4 3))
(check-equal? (visit-d t2) '(6))
(check-equal? (visit-d t3) '())

