(comment "CPSA 4.3.0")
(comment "All input read from tst/deorig_contract.scm")

(defprotocol deorig-contract basic
  (defrole init
    (vars (k akey) (x1 x2 text))
    (trace (send (enc x1 k)) (send (enc x2 k)) (recv (enc x1 x2 k)))
    (non-orig (invk k))
    (uniq-orig x1 x2))
  (defrole resp
    (vars (k akey) (y1 y2 y3 text))
    (trace (recv (enc y1 k)) (recv (enc y2 k)) (send (enc y1 y3 k))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1))))))

(defskeleton deorig-contract
  (vars (x1 x2 text) (k akey))
  (defstrand init 3 (x1 x1) (x2 x2) (k k))
  (non-orig (invk k))
  (uniq-orig x1 x2)
  (traces ((send (enc x1 k)) (send (enc x2 k)) (recv (enc x1 x2 k))))
  (label 0)
  (unrealized (0 2))
  (origs (x2 (0 1)) (x1 (0 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton deorig-contract
  (vars (x1 x2 y2 y3 text) (k akey))
  (defstrand init 3 (x1 x1) (x2 x2) (k k))
  (defstrand resp 3 (y1 x1) (y2 y2) (y3 y3) (k k))
  (precedes ((0 0) (1 0)) ((1 2) (0 2)))
  (non-orig (invk k))
  (uniq-orig x1 x2)
  (operation nonce-test (added-strand resp 3) x1 (0 2) (enc x1 k))
  (traces ((send (enc x1 k)) (send (enc x2 k)) (recv (enc x1 x2 k)))
    ((recv (enc x1 k)) (recv (enc y2 k)) (send (enc x1 y3 k))))
  (label 1)
  (parent 0)
  (unrealized (0 2))
  (dead)
  (comment "empty cohort"))

(comment "Nothing left to do")

(defprotocol deorig-contract basic
  (defrole init
    (vars (k akey) (x1 x2 text))
    (trace (send (enc x1 k)) (send (enc x2 k)) (recv (enc x1 x2 k)))
    (non-orig (invk k))
    (uniq-orig x1 x2))
  (defrole resp
    (vars (k akey) (y1 y2 y3 text))
    (trace (recv (enc y1 k)) (recv (enc y2 k)) (send (enc y1 y3 k))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1))))))

(defskeleton deorig-contract
  (vars (x1 x2 text) (k akey))
  (defstrand init 3 (x1 x1) (x2 x2) (k k))
  (defstrand resp 3 (y1 x1) (y2 x2) (y3 x2) (k k))
  (precedes ((0 0) (1 0)) ((0 1) (1 1)) ((1 2) (0 2)))
  (non-orig (invk k))
  (uniq-orig x1 x2)
  (traces ((send (enc x1 k)) (send (enc x2 k)) (recv (enc x1 x2 k)))
    ((recv (enc x1 k)) (recv (enc x2 k)) (send (enc x1 x2 k))))
  (label 2)
  (unrealized)
  (shape)
  (maps ((0 1) ((k k) (x1 x1) (x2 x2))))
  (origs (x2 (0 1)) (x1 (0 0))))

(comment "Nothing left to do")
