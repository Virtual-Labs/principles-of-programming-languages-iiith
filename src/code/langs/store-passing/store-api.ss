;;; API for References and Stores
;;; =============================

;;; A store is an abstract datatype 


;;; store?
;;; ------

;;; type predicate for store

;;; ref?
;;; ----
;;; type predicate for a reference:


;;; storable-value?
;;; ---------------
;;; type predicate for storable values


;;; empty-store: store?

;;; store-size
;;; ----------
;;; returns the size of the current store
;;; store-size: store? -> nat


;;; deref
;;; -----

;;; deref: [store? ref?] -> storable-value?

;;; setref
;;; ------

;;; takes a store s, a reference r and a storable value v
;;; and returns a new store that is like s except that it
;;; maps r to v.

;;; setref : [store? ref? storable-value?] -> store?

;;; new-ref
;;; -------

;;; takes a store and returns a new store which is the same
;;; as before, except that a new reference is created and its

;;; new-ref: [store? storable-value?] -> [store?, ref?]


