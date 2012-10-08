;; ========================================
;; Implementation of a while loop in Scheme
;; ========================================

;; Author: Venkatesh Choppella <choppell@gmail.com>


;; The while loop defined below works on a list of 2
;; elements.  This list determines the state of the
;; iteration system. 

;; The while loop is a function that takes the following parameters:

;; * init, which is a function that returns a list of two elements

;; * exit-test, which returns a boolean

;; * next, which computes the next state from the current one.

;; * result, which takes the state and returns a value.

;; The while loop implements a state machine that starts
;; with an initial state (specified by the init function),
;; checks for the exit condition (exit-test function), and
;; returns a result if the exit condition is true (result
;; function).  If the condition is false, it computes the
;; next step (next function) and iterates.


;; while : [ init :      [()        -> (any any)]
;;           exit-test : [(any any) -> boolean? ]
;;           next :      [(any any) -> (any any)]
;;           result :    [(any any) -> any      ]
;;         ] -> any

(define while
  (lambda (init exit-test next result)
    (letrec ([loop
               (lambda (v)
                 (let ([m (list-ref v 0)]
                       [a (list-ref v 1)])
                   (cond
                     [(exit-test m a) (result m a)]
                     [else
                       (loop (next m a))])))])
      (loop (init)))))


;; factorial using while
;; ! : nat? -> nat?
(define !
  (lambda (n)
    (while

      ;; init : () -> (nat? nat?)
      (lambda ()
        (list n 1))

      ;; test : [nat? nat?] -> boolean
      (lambda (m a)
        (zero? m))

      ;; next : [nat? nat?] -> (nat? nat?)
      (lambda (m a)
        (list (sub1 m) (* m a)))

      ;; result : [nat? nat?] -> nat?
      (lambda (m a)
        a))))

;; list-length using while

;; list-length : list? -> nat?

(define list-length
  (lambda (ls)
    (while
      ;; init : () -> (list? nat?)
      (lambda ()
        (list ls 0))

      ;; test : [list? nat?] -> boolean?
      (lambda (ls a)
        (null? ls))

      ;; next : [list? nat?] -> (list? nat?)
      (lambda (ls a)
        (list (cdr ls) (+ 1 a)))

      ;; result : [list? nat?] -> nat?
      (lambda (ls a)
        a))))

;;; Sorry, no unit-tests yet:-(