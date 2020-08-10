(herald "Privacy Certificate Authority" (bound 15)
  (comment "Generation of an Attestation Identity Certificate"))

(comment "CPSA 4.3.0")
(comment "All input read from tst/pca.scm")
(comment "Strand count bounded at 15")

(defprotocol pca basic
  (defrole tpm
    (vars (ke ki km kp akey) (t a text))
    (trace (send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    (non-orig (invk ke) (invk ki) (invk km) (invk kp))
    (uniq-orig ki))
  (defrole pca
    (vars (ke ki km kp akey) (t a text))
    (trace (recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    (non-orig (invk ke) (invk ki) (invk km) (invk kp)))
  (defrole appr
    (vars (ki kp akey) (t a text))
    (trace (recv (enc ki a t (invk kp))))
    (non-orig (invk ki) (invk kp)))
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

(defskeleton pca
  (vars (t a text) (ki kp akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (non-orig (invk ki) (invk kp))
  (traces ((recv (enc ki a t (invk kp)))))
  (label 0)
  (unrealized (0 0))
  (origs)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton pca
  (vars (t a text) (ki kp ke km akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (precedes ((1 1) (0 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km))
  (operation encryption-test (added-strand pca 2) (enc ki a t (invk kp))
    (0 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke))))
  (label 1)
  (parent 0)
  (unrealized (0 0) (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton pca
  (vars (t a t-0 text) (ki kp ke km ke-0 km-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t-0) (a a) (ke ke-0) (ki ki) (km km-0))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ke-0)
    (invk km-0))
  (uniq-orig ki)
  (operation encryption-test (added-strand tpm 1) (enc ki a (invk ki))
    (1 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t-0 ke-0 (invk km-0))))))
  (label 2)
  (parent 1)
  (unrealized (0 0) (1 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton pca
  (vars (a t text) (ki kp ke km akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a) (ke ke) (ki ki) (km km))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km))
  (uniq-orig ki)
  (operation encryption-test (displaced 3 2 tpm 1)
    (enc t-0 ke-0 (invk km-0)) (1 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))))
  (label 3)
  (parent 2)
  (unrealized (0 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton pca
  (vars (t a t-0 a-0 text) (ki kp ke km ke-0 km-0 ki-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t-0) (a a) (ke ke-0) (ki ki) (km km-0))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((3 0) (1 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ke-0)
    (invk km-0) (invk ki-0))
  (uniq-orig ki ki-0)
  (operation encryption-test (added-strand tpm 1) (enc t ke (invk km))
    (1 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t-0 ke-0 (invk km-0)))))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km))))))
  (label 4)
  (parent 2)
  (unrealized (0 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton pca
  (vars (a t text) (ki kp ke km akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((2 2) (0 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km))
  (uniq-orig ki)
  (operation encryption-test (displaced 2 3 tpm 3)
    (enc ki a t (invk kp)) (0 0) (enc (enc ki a t (invk kp)) ke))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp)))))
  (label 5)
  (parent 3)
  (unrealized (2 1))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton pca
  (vars (a t text) (ki kp ke km ke-0 km-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a) (ke ke) (ki ki) (km km))
  (defstrand pca 2 (t t) (a a) (ke ke-0) (ki ki) (km km-0) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((2 0) (3 0)) ((3 1) (0 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ke-0)
    (invk km-0))
  (uniq-orig ki)
  (operation encryption-test (added-strand pca 2) (enc ki a t (invk kp))
    (0 0) (enc (enc ki a t (invk kp)) ke))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km)))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-0 (invk km-0))))
      (send (enc (enc ki a t (invk kp)) ke-0))))
  (label 6)
  (parent 3)
  (seen 3)
  (unrealized (0 0) (3 0))
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (t a a-0 text) (ki kp ke km ki-0 km-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((3 0) (1 0)) ((3 2) (0 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0))
  (uniq-orig ki ki-0)
  (operation encryption-test (displaced 2 4 tpm 3)
    (enc ki a t (invk kp)) (0 0) (enc (enc ki a t (invk kp)) ke))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp)))))
  (label 7)
  (parent 4)
  (unrealized (3 1))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton pca
  (vars (t a t-0 a-0 text) (ki kp ke km ke-0 km-0 ki-0 ke-1 km-1 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t-0) (a a) (ke ke-0) (ki ki) (km km-0))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand pca 2 (t t) (a a) (ke ke-1) (ki ki) (km km-1) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((2 0) (4 0)) ((3 0) (1 0))
    ((4 1) (0 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ke-0)
    (invk km-0) (invk ki-0) (invk ke-1) (invk km-1))
  (uniq-orig ki ki-0)
  (operation encryption-test (added-strand pca 2) (enc ki a t (invk kp))
    (0 0) (enc (enc ki a t (invk kp)) ke))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t-0 ke-0 (invk km-0)))))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-1 (invk km-1))))
      (send (enc (enc ki a t (invk kp)) ke-1))))
  (label 8)
  (parent 4)
  (seen 4)
  (unrealized (0 0) (4 0))
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (a t text) (ki kp ke km akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (precedes ((1 1) (2 1)) ((2 0) (1 0)) ((2 2) (0 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km))
  (uniq-orig ki)
  (operation encryption-test (displaced 3 1 pca 2)
    (enc ki a t (invk kp)) (2 1))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp)))))
  (label 9)
  (parent 5)
  (unrealized)
  (shape)
  (maps ((0) ((ki ki) (kp kp) (t t) (a a))))
  (origs (ki (2 0))))

(defskeleton pca
  (vars (a t text) (ki kp ke km ke-0 km-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke-0) (ki ki) (km km-0) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((2 0) (3 0)) ((2 2) (0 0))
    ((3 1) (2 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ke-0)
    (invk km-0))
  (uniq-orig ki)
  (operation encryption-test (added-strand pca 2) (enc ki a t (invk kp))
    (2 1))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-0 (invk km-0))))
      (send (enc (enc ki a t (invk kp)) ke-0))))
  (label 10)
  (parent 5)
  (unrealized (2 1) (3 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton pca
  (vars (t a a-0 text) (ki kp ke km ki-0 km-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (precedes ((1 1) (3 1)) ((2 0) (1 0)) ((3 0) (1 0)) ((3 2) (0 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0))
  (uniq-orig ki ki-0)
  (operation encryption-test (displaced 4 1 pca 2)
    (enc ki a t (invk kp)) (3 1))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp)))))
  (label 11)
  (parent 7)
  (unrealized)
  (shape)
  (maps ((0) ((ki ki) (kp kp) (t t) (a a))))
  (origs (ki (3 0)) (ki-0 (2 0))))

(defskeleton pca
  (vars (t a a-0 text) (ki kp ke km ki-0 km-0 ke-0 km-1 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke-0) (ki ki) (km km-1) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((3 0) (1 0)) ((3 0) (4 0))
    ((3 2) (0 0)) ((4 1) (3 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0) (invk ke-0) (invk km-1))
  (uniq-orig ki ki-0)
  (operation encryption-test (added-strand pca 2) (enc ki a t (invk kp))
    (3 1))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-0 (invk km-1))))
      (send (enc (enc ki a t (invk kp)) ke-0))))
  (label 12)
  (parent 7)
  (unrealized (3 1) (4 0))
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton pca
  (vars (a t text) (ki kp ke km akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((2 0) (3 0)) ((2 2) (0 0))
    ((3 1) (2 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km))
  (uniq-orig ki)
  (operation encryption-test (displaced 4 2 tpm 1)
    (enc t ke-0 (invk km-0)) (3 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke))))
  (label 13)
  (parent 10)
  (seen 9)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (a t a-0 text) (ki kp ke km ke-0 km-0 ki-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke-0) (ki ki) (km km-0) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke-0) (ki ki-0) (km km-0))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((2 0) (3 0)) ((2 2) (0 0))
    ((3 1) (2 1)) ((4 0) (3 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ke-0)
    (invk km-0) (invk ki-0))
  (uniq-orig ki ki-0)
  (operation encryption-test (added-strand tpm 1)
    (enc t ke-0 (invk km-0)) (3 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-0 (invk km-0))))
      (send (enc (enc ki a t (invk kp)) ke-0)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke-0 (invk km-0))))))
  (label 14)
  (parent 10)
  (unrealized (2 1))
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton pca
  (vars (t a a-0 text) (ki kp ke km ki-0 km-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((2 0) (4 0)) ((3 0) (1 0))
    ((3 0) (4 0)) ((3 2) (0 0)) ((4 1) (3 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0))
  (uniq-orig ki ki-0)
  (operation encryption-test (displaced 5 2 tpm 1)
    (enc t ke-0 (invk km-1)) (4 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke))))
  (label 15)
  (parent 12)
  (seen 11)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (t a a-0 text) (ki kp ke km ki-0 km-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((3 0) (1 0)) ((3 0) (4 0))
    ((3 2) (0 0)) ((4 1) (3 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0))
  (uniq-orig ki ki-0)
  (operation encryption-test (displaced 5 3 tpm 1)
    (enc t ke-0 (invk km-1)) (4 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (send (enc (enc ki a t (invk kp)) ke))))
  (label 16)
  (parent 12)
  (unrealized)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton pca
  (vars (t a a-0 a-1 text) (ki kp ke km ki-0 km-0 ke-0 km-1 ki-1 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke-0) (ki ki) (km km-1) (kp kp))
  (defstrand tpm 1 (t t) (a a-1) (ke ke-0) (ki ki-1) (km km-1))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((3 0) (1 0)) ((3 0) (4 0))
    ((3 2) (0 0)) ((4 1) (3 1)) ((5 0) (4 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0) (invk ke-0) (invk km-1) (invk ki-1))
  (uniq-orig ki ki-0 ki-1)
  (operation encryption-test (added-strand tpm 1)
    (enc t ke-0 (invk km-1)) (4 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-0 (invk km-1))))
      (send (enc (enc ki a t (invk kp)) ke-0)))
    ((send (cat (enc ki-1 a-1 (invk ki-1)) (enc t ke-0 (invk km-1))))))
  (label 17)
  (parent 12)
  (unrealized (3 1))
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton pca
  (vars (a t a-0 text) (ki kp km ke km-0 ki-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km-0))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((2 0) (3 0)) ((2 2) (0 0))
    ((3 1) (2 1)) ((4 0) (3 0)))
  (non-orig (invk ki) (invk kp) (invk km) (invk ke) (invk km-0)
    (invk ki-0))
  (uniq-orig ki ki-0)
  (operation encryption-test (contracted (ke-0 ke))
    (enc ki a t (invk kp)) (2 1) (enc (enc ki a t (invk kp)) ke))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km-0))))))
  (label 18)
  (parent 14)
  (seen 11)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (a t a-0 text) (ki kp ke km ke-0 km-0 ki-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke-0) (ki ki) (km km-0) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke-0) (ki ki-0) (km km-0))
  (precedes ((1 1) (2 1)) ((2 0) (1 0)) ((2 0) (3 0)) ((2 2) (0 0))
    ((3 1) (2 1)) ((4 0) (3 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ke-0)
    (invk km-0) (invk ki-0))
  (uniq-orig ki ki-0)
  (operation encryption-test (displaced 5 1 pca 2)
    (enc ki a t (invk kp)) (2 1) (enc (enc ki a t (invk kp)) ke-0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-0 (invk km-0))))
      (send (enc (enc ki a t (invk kp)) ke-0)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke-0 (invk km-0))))))
  (label 19)
  (parent 14)
  (unrealized)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton pca
  (vars (a t a-0 text) (ki kp ke km ke-0 km-0 ki-0 ke-1 km-1 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke-0) (ki ki) (km km-0) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke-0) (ki ki-0) (km km-0))
  (defstrand pca 2 (t t) (a a) (ke ke-1) (ki ki) (km km-1) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((2 0) (3 0)) ((2 0) (5 0))
    ((2 2) (0 0)) ((3 1) (2 1)) ((4 0) (3 0)) ((5 1) (2 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ke-0)
    (invk km-0) (invk ki-0) (invk ke-1) (invk km-1))
  (uniq-orig ki ki-0)
  (operation encryption-test (added-strand pca 2) (enc ki a t (invk kp))
    (2 1) (enc (enc ki a t (invk kp)) ke-0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-0 (invk km-0))))
      (send (enc (enc ki a t (invk kp)) ke-0)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke-0 (invk km-0)))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-1 (invk km-1))))
      (send (enc (enc ki a t (invk kp)) ke-1))))
  (label 20)
  (parent 14)
  (seen 14)
  (unrealized (2 1) (5 0))
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (t a a-0 text) (ki kp ke km ki-0 km-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (precedes ((1 0) (0 0)) ((2 0) (3 0)) ((2 2) (0 0)) ((3 1) (2 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0))
  (uniq-orig ki ki-0)
  (operation generalization deleted (1 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (send (enc (enc ki a t (invk kp)) ke))))
  (label 21)
  (parent 16)
  (seen 9)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (t a a-0 a-1 text) (ki kp km ki-0 km-0 ke km-1 ki-1 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km-1) (kp kp))
  (defstrand tpm 1 (t t) (a a-1) (ke ke) (ki ki-1) (km km-1))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((3 0) (1 0)) ((3 0) (4 0))
    ((3 2) (0 0)) ((4 1) (3 1)) ((5 0) (4 0)))
  (non-orig (invk ki) (invk kp) (invk km) (invk ki-0) (invk km-0)
    (invk ke) (invk km-1) (invk ki-1))
  (uniq-orig ki ki-0 ki-1)
  (operation encryption-test (contracted (ke-0 ke))
    (enc ki a t (invk kp)) (3 1) (enc (enc ki a t (invk kp)) ke))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km-1))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-1 a-1 (invk ki-1)) (enc t ke (invk km-1))))))
  (label 22)
  (parent 17)
  (unrealized)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton pca
  (vars (t a a-0 a-1 text) (ki kp ke km ki-0 km-0 ke-0 km-1 ki-1 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke-0) (ki ki) (km km-1) (kp kp))
  (defstrand tpm 1 (t t) (a a-1) (ke ke-0) (ki ki-1) (km km-1))
  (precedes ((1 1) (3 1)) ((2 0) (1 0)) ((3 0) (1 0)) ((3 0) (4 0))
    ((3 2) (0 0)) ((4 1) (3 1)) ((5 0) (4 0)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0) (invk ke-0) (invk km-1) (invk ki-1))
  (uniq-orig ki ki-0 ki-1)
  (operation encryption-test (displaced 6 1 pca 2)
    (enc ki a t (invk kp)) (3 1) (enc (enc ki a t (invk kp)) ke-0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-0 (invk km-1))))
      (send (enc (enc ki a t (invk kp)) ke-0)))
    ((send (cat (enc ki-1 a-1 (invk ki-1)) (enc t ke-0 (invk km-1))))))
  (label 23)
  (parent 17)
  (unrealized)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton pca
  (vars (t a a-0 a-1 text)
    (ki kp ke km ki-0 km-0 ke-0 km-1 ki-1 ke-1 km-2 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke-0) (ki ki) (km km-1) (kp kp))
  (defstrand tpm 1 (t t) (a a-1) (ke ke-0) (ki ki-1) (km km-1))
  (defstrand pca 2 (t t) (a a) (ke ke-1) (ki ki) (km km-2) (kp kp))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)) ((3 0) (1 0)) ((3 0) (4 0))
    ((3 0) (6 0)) ((3 2) (0 0)) ((4 1) (3 1)) ((5 0) (4 0))
    ((6 1) (3 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0) (invk ke-0) (invk km-1) (invk ki-1) (invk ke-1)
    (invk km-2))
  (uniq-orig ki ki-0 ki-1)
  (operation encryption-test (added-strand pca 2) (enc ki a t (invk kp))
    (3 1) (enc (enc ki a t (invk kp)) ke-0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-0 (invk km-1))))
      (send (enc (enc ki a t (invk kp)) ke-0)))
    ((send (cat (enc ki-1 a-1 (invk ki-1)) (enc t ke-0 (invk km-1)))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke-1 (invk km-2))))
      (send (enc (enc ki a t (invk kp)) ke-1))))
  (label 24)
  (parent 17)
  (seen 17)
  (unrealized (3 1) (6 0))
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (a t a-0 text) (ki kp ke km ke-0 km-0 ki-0 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke-0) (ki ki-0) (km km-0))
  (precedes ((1 1) (2 1)) ((2 0) (1 0)) ((2 2) (0 0)) ((3 0) (2 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ke-0)
    (invk km-0) (invk ki-0))
  (uniq-orig ki ki-0)
  (operation generalization deleted (3 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke-0 (invk km-0))))))
  (label 25)
  (parent 19)
  (seen 9)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (t a a-0 a-1 text) (ki kp km ki-0 km-0 ke km-1 ki-1 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km-1) (kp kp))
  (defstrand tpm 1 (t t) (a a-1) (ke ke) (ki ki-1) (km km-1))
  (precedes ((1 0) (0 0)) ((2 0) (3 0)) ((2 2) (0 0)) ((3 1) (2 1))
    ((4 0) (3 0)))
  (non-orig (invk ki) (invk kp) (invk km) (invk ki-0) (invk km-0)
    (invk ke) (invk km-1) (invk ki-1))
  (uniq-orig ki ki-0 ki-1)
  (operation generalization deleted (1 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km-1))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-1 a-1 (invk ki-1)) (enc t ke (invk km-1))))))
  (label 26)
  (parent 22)
  (seen 11)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton pca
  (vars (t a a-0 a-1 text) (ki kp ke km ki-0 km-0 ke-0 km-1 ki-1 akey))
  (defstrand appr 1 (t t) (a a) (ki ki) (kp kp))
  (defstrand pca 2 (t t) (a a) (ke ke) (ki ki) (km km) (kp kp))
  (defstrand tpm 1 (t t) (a a-0) (ke ke) (ki ki-0) (km km))
  (defstrand tpm 3 (t t) (a a) (ke ke) (ki ki) (km km-0) (kp kp))
  (defstrand tpm 1 (t t) (a a-1) (ke ke-0) (ki ki-1) (km km-1))
  (precedes ((1 1) (3 1)) ((2 0) (1 0)) ((3 0) (1 0)) ((3 2) (0 0))
    ((4 0) (3 1)))
  (non-orig (invk ki) (invk kp) (invk ke) (invk km) (invk ki-0)
    (invk km-0) (invk ke-0) (invk km-1) (invk ki-1))
  (uniq-orig ki ki-0 ki-1)
  (operation generalization deleted (4 0))
  (traces ((recv (enc ki a t (invk kp))))
    ((recv (cat (enc ki a (invk ki)) (enc t ke (invk km))))
      (send (enc (enc ki a t (invk kp)) ke)))
    ((send (cat (enc ki-0 a-0 (invk ki-0)) (enc t ke (invk km)))))
    ((send (cat (enc ki a (invk ki)) (enc t ke (invk km-0))))
      (recv (enc (enc ki a t (invk kp)) ke))
      (send (enc ki a t (invk kp))))
    ((send (cat (enc ki-1 a-1 (invk ki-1)) (enc t ke-0 (invk km-1))))))
  (label 27)
  (parent 23)
  (seen 11)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(comment "Nothing left to do")
