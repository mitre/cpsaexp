(herald perrig-song)

(comment "CPSA 4.3.0")
(comment "All input read from tst/chan-perrig-song.scm")

(defprotocol perrig-song basic
  (defrole init
    (vars (na nb text) (a b name) (c chan))
    (trace (send na) (recv c (cat na nb a b)) (send nb)))
  (defrole resp
    (vars (na nb text) (a b name) (c chan))
    (trace (recv na) (send c (cat na nb a b)) (recv nb)))
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

(defskeleton perrig-song
  (vars (na nb text) (a b name) (c chan))
  (defstrand init 2 (na na) (nb nb) (a a) (b b) (c c))
  (uniq-orig na)
  (auth c)
  (traces ((send na) (recv c (cat na nb a b))))
  (label 0)
  (unrealized (0 1))
  (origs (na (0 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton perrig-song
  (vars (na nb text) (a b name) (c chan))
  (defstrand init 2 (na na) (nb nb) (a a) (b b) (c c))
  (defstrand resp 2 (na na) (nb nb) (a a) (b b) (c c))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (uniq-orig na)
  (auth c)
  (operation channel-test (added-strand resp 2)
    (ch-msg c (cat na nb a b)) (0 1))
  (traces ((send na) (recv c (cat na nb a b)))
    ((recv na) (send c (cat na nb a b))))
  (label 1)
  (parent 0)
  (unrealized)
  (shape)
  (maps ((0) ((na na) (c c) (nb nb) (a a) (b b))))
  (origs (na (0 0))))

(comment "Nothing left to do")

(defprotocol perrig-song basic
  (defrole init
    (vars (na nb text) (a b name) (c chan))
    (trace (send na) (recv c (cat na nb a b)) (send nb)))
  (defrole resp
    (vars (na nb text) (a b name) (c chan))
    (trace (recv na) (send c (cat na nb a b)) (recv nb)))
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

(defskeleton perrig-song
  (vars (nb na text) (a b name) (c chan))
  (defstrand resp 3 (na na) (nb nb) (a a) (b b) (c c))
  (uniq-orig nb)
  (conf c)
  (traces ((recv na) (send c (cat na nb a b)) (recv nb)))
  (label 2)
  (unrealized (0 2))
  (origs (nb (0 1)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton perrig-song
  (vars (nb na text) (a b name) (c chan))
  (defstrand resp 3 (na na) (nb nb) (a a) (b b) (c c))
  (defstrand init 3 (na na) (nb nb) (a a) (b b) (c c))
  (precedes ((0 1) (1 1)) ((1 2) (0 2)))
  (uniq-orig nb)
  (conf c)
  (operation nonce-test (added-strand init 3) nb (0 2)
    (ch-msg c (cat na nb a b)))
  (traces ((recv na) (send c (cat na nb a b)) (recv nb))
    ((send na) (recv c (cat na nb a b)) (send nb)))
  (label 3)
  (parent 2)
  (unrealized)
  (shape)
  (maps ((0) ((nb nb) (c c) (na na) (a a) (b b))))
  (origs (nb (0 1))))

(comment "Nothing left to do")

(defprotocol perrig-song basic
  (defrole init
    (vars (na nb text) (a b name) (c chan))
    (trace (send na) (recv c (cat na nb a b)) (send nb)))
  (defrole resp
    (vars (na nb text) (a b name) (c chan))
    (trace (recv na) (send c (cat na nb a b)) (recv nb)))
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

(defskeleton perrig-song
  (vars (na nb text) (a b name) (c chan))
  (defstrand init 2 (na na) (nb nb) (a a) (b b) (c c))
  (uniq-orig na)
  (conf c)
  (traces ((send na) (recv c (cat na nb a b))))
  (label 4)
  (unrealized)
  (shape)
  (maps ((0) ((na na) (c c) (nb nb) (a a) (b b))))
  (origs (na (0 0))))

(comment "Nothing left to do")

(defprotocol perrig-song basic
  (defrole init
    (vars (na nb text) (a b name) (c chan))
    (trace (send na) (recv c (cat na nb a b)) (send nb)))
  (defrole resp
    (vars (na nb text) (a b name) (c chan))
    (trace (recv na) (send c (cat na nb a b)) (recv nb)))
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

(defskeleton perrig-song
  (vars (nb na text) (a b name) (c chan))
  (defstrand resp 3 (na na) (nb nb) (a a) (b b) (c c))
  (uniq-orig nb)
  (auth c)
  (traces ((recv na) (send c (cat na nb a b)) (recv nb)))
  (label 5)
  (unrealized)
  (shape)
  (maps ((0) ((nb nb) (c c) (na na) (a a) (b b))))
  (origs (nb (0 1))))

(comment "Nothing left to do")
