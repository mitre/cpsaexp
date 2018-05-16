(herald reflect)

(comment "CPSA 4.1.1")
(comment "All input read from reflect.scm")

(defprotocol reflect basic
  (defrole init
    (vars (a b akey))
    (trace (send (enc b (invk a))) (recv (enc a (invk b)))))
  (defrole resp
    (vars (a b akey))
    (trace (recv (enc b (invk a))) (send (enc a (invk b))))))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (non-orig (invk a) (invk b))
  (traces ((recv (enc b (invk a)))))
  (label 0)
  (unrealized (0 0))
  (origs)
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand init 1 (a a) (b b))
  (precedes ((1 0) (0 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand init 1) (enc b (invk a))
    (0 0))
  (traces ((recv (enc b (invk a)))) ((send (enc b (invk a)))))
  (label 1)
  (parent 0)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b))))
  (origs))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (precedes ((1 1) (0 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand resp 2) (enc b (invk a))
    (0 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc a (invk b))) (send (enc b (invk a)))))
  (label 2)
  (parent 0)
  (unrealized (1 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand init 1 (a b) (b a))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand init 1) (enc a (invk b))
    (1 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((send (enc a (invk b)))))
  (label 3)
  (parent 2)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b))))
  (origs))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand resp 2 (a a) (b b))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand resp 2) (enc a (invk b))
    (1 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((recv (enc b (invk a))) (send (enc a (invk b)))))
  (label 4)
  (parent 2)
  (unrealized (2 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand resp 2 (a a) (b b))
  (defstrand init 1 (a a) (b b))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)) ((3 0) (2 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand init 1) (enc b (invk a))
    (2 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((send (enc b (invk a)))))
  (label 5)
  (parent 4)
  (unrealized)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand resp 2 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)) ((3 1) (2 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand resp 2) (enc b (invk a))
    (2 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((recv (enc a (invk b))) (send (enc b (invk a)))))
  (label 6)
  (parent 4)
  (seen 4)
  (unrealized (3 0))
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a a) (b b))
  (defstrand init 1 (a a) (b b))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)))
  (non-orig (invk a) (invk b))
  (operation generalization deleted (1 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((send (enc b (invk a)))))
  (label 7)
  (parent 5)
  (seen 1)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(comment "Nothing left to do")

(defprotocol reflect basic
  (defrole init
    (vars (a b akey))
    (trace (send (enc b (invk a))) (recv (enc a (invk b)))))
  (defrole resp
    (vars (a b akey))
    (trace (recv (enc b (invk a))) (send (enc a (invk b))))))

(defskeleton reflect
  (vars (a b akey))
  (defstrand init 2 (a a) (b b))
  (non-orig (invk a) (invk b))
  (traces ((send (enc b (invk a))) (recv (enc a (invk b)))))
  (label 8)
  (unrealized (0 1))
  (origs)
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton reflect
  (vars (b akey))
  (defstrand init 2 (a b) (b b))
  (non-orig (invk b))
  (operation encryption-test (displaced 1 0 init 1) (enc a (invk b))
    (0 1))
  (traces ((send (enc b (invk b))) (recv (enc b (invk b)))))
  (label 9)
  (parent 8)
  (unrealized)
  (shape)
  (maps ((0) ((a b) (b b))))
  (origs))

(defskeleton reflect
  (vars (a b akey))
  (defstrand init 2 (a a) (b b))
  (defstrand init 1 (a b) (b a))
  (precedes ((1 0) (0 1)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand init 1) (enc a (invk b))
    (0 1))
  (traces ((send (enc b (invk a))) (recv (enc a (invk b))))
    ((send (enc a (invk b)))))
  (label 10)
  (parent 8)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b))))
  (origs))

(defskeleton reflect
  (vars (a b akey))
  (defstrand init 2 (a a) (b b))
  (defstrand resp 2 (a a) (b b))
  (precedes ((1 1) (0 1)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand resp 2) (enc a (invk b))
    (0 1))
  (traces ((send (enc b (invk a))) (recv (enc a (invk b))))
    ((recv (enc b (invk a))) (send (enc a (invk b)))))
  (label 11)
  (parent 8)
  (unrealized (1 0))
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand init 2 (a a) (b b))
  (defstrand resp 2 (a a) (b b))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (displaced 2 0 init 1) (enc b (invk a))
    (1 0))
  (traces ((send (enc b (invk a))) (recv (enc a (invk b))))
    ((recv (enc b (invk a))) (send (enc a (invk b)))))
  (label 12)
  (parent 11)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b))))
  (origs))

(defskeleton reflect
  (vars (a b akey))
  (defstrand init 2 (a a) (b b))
  (defstrand resp 2 (a a) (b b))
  (defstrand init 1 (a a) (b b))
  (precedes ((1 1) (0 1)) ((2 0) (1 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand init 1) (enc b (invk a))
    (1 0))
  (traces ((send (enc b (invk a))) (recv (enc a (invk b))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((send (enc b (invk a)))))
  (label 13)
  (parent 11)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b))))
  (origs))

(defskeleton reflect
  (vars (a b akey))
  (defstrand init 2 (a a) (b b))
  (defstrand resp 2 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (precedes ((1 1) (0 1)) ((2 1) (1 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand resp 2) (enc b (invk a))
    (1 0))
  (traces ((send (enc b (invk a))) (recv (enc a (invk b))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((recv (enc a (invk b))) (send (enc b (invk a)))))
  (label 14)
  (parent 11)
  (unrealized (2 0))
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton reflect
  (vars (b akey))
  (defstrand init 2 (a b) (b b))
  (defstrand resp 2 (a b) (b b))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk b))
  (operation encryption-test (displaced 3 0 init 1) (enc a (invk b))
    (2 0))
  (traces ((send (enc b (invk b))) (recv (enc b (invk b))))
    ((recv (enc b (invk b))) (send (enc b (invk b)))))
  (label 15)
  (parent 14)
  (seen 9)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand init 2 (a a) (b b))
  (defstrand resp 2 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand init 1 (a b) (b a))
  (precedes ((1 1) (0 1)) ((2 1) (1 0)) ((3 0) (2 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand init 1) (enc a (invk b))
    (2 0))
  (traces ((send (enc b (invk a))) (recv (enc a (invk b))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((send (enc a (invk b)))))
  (label 16)
  (parent 14)
  (unrealized)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand init 2 (a a) (b b))
  (defstrand resp 2 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand resp 2 (a a) (b b))
  (precedes ((1 1) (0 1)) ((2 1) (1 0)) ((3 1) (2 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand resp 2) (enc a (invk b))
    (2 0))
  (traces ((send (enc b (invk a))) (recv (enc a (invk b))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((recv (enc b (invk a))) (send (enc a (invk b)))))
  (label 17)
  (parent 14)
  (seen 14)
  (unrealized (3 0))
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand init 2 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand init 1 (a b) (b a))
  (precedes ((1 1) (0 1)) ((2 0) (1 0)))
  (non-orig (invk a) (invk b))
  (operation generalization deleted (1 0))
  (traces ((send (enc b (invk a))) (recv (enc a (invk b))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((send (enc a (invk b)))))
  (label 18)
  (parent 16)
  (seen 10)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(comment "Nothing left to do")

(defprotocol reflect basic
  (defrole init
    (vars (a b akey))
    (trace (send (enc b (invk a))) (recv (enc a (invk b)))))
  (defrole resp
    (vars (a b akey))
    (trace (recv (enc b (invk a))) (send (enc a (invk b))))))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b (invk b)))
  (non-orig b (invk a))
  (traces ((recv (enc (invk b) (invk a)))))
  (label 19)
  (unrealized (0 0))
  (origs)
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b (invk b)))
  (defstrand init 1 (a a) (b (invk b)))
  (precedes ((1 0) (0 0)))
  (non-orig b (invk a))
  (operation encryption-test (added-strand init 1)
    (enc (invk b) (invk a)) (0 0))
  (traces ((recv (enc (invk b) (invk a))))
    ((send (enc (invk b) (invk a)))))
  (label 20)
  (parent 19)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b))))
  (origs))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b (invk b)))
  (defstrand resp 2 (a (invk b)) (b a))
  (precedes ((1 1) (0 0)))
  (non-orig b (invk a))
  (operation encryption-test (added-strand resp 2)
    (enc (invk b) (invk a)) (0 0))
  (traces ((recv (enc (invk b) (invk a))))
    ((recv (enc a b)) (send (enc (invk b) (invk a)))))
  (label 21)
  (parent 19)
  (unrealized (1 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton reflect
  (vars (a a-0 akey))
  (defstrand resp 1 (a a) (b a-0))
  (defstrand resp 2 (a a-0) (b a))
  (defstrand init 1 (a a-0) (b a))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)))
  (non-orig (invk a) (invk a-0))
  (operation encryption-test (added-strand init 1) (enc a (invk a-0))
    (1 0))
  (traces ((recv (enc a-0 (invk a))))
    ((recv (enc a (invk a-0))) (send (enc a-0 (invk a))))
    ((send (enc a (invk a-0)))))
  (label 22)
  (parent 21)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b (invk a-0)))))
  (origs))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand resp 2 (a a) (b b))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand resp 2) (enc a (invk b))
    (1 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((recv (enc b (invk a))) (send (enc a (invk b)))))
  (label 23)
  (parent 21)
  (unrealized (2 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand resp 2 (a a) (b b))
  (defstrand init 1 (a a) (b b))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)) ((3 0) (2 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand init 1) (enc b (invk a))
    (2 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((send (enc b (invk a)))))
  (label 24)
  (parent 23)
  (unrealized)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (defstrand resp 2 (a a) (b b))
  (defstrand resp 2 (a b) (b a))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)) ((3 1) (2 0)))
  (non-orig (invk a) (invk b))
  (operation encryption-test (added-strand resp 2) (enc b (invk a))
    (2 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc a (invk b))) (send (enc b (invk a))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((recv (enc a (invk b))) (send (enc b (invk a)))))
  (label 25)
  (parent 23)
  (seen 23)
  (unrealized (3 0))
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton reflect
  (vars (a b akey))
  (defstrand resp 1 (a a) (b b))
  (defstrand resp 2 (a a) (b b))
  (defstrand init 1 (a a) (b b))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)))
  (non-orig (invk a) (invk b))
  (operation generalization deleted (1 0))
  (traces ((recv (enc b (invk a))))
    ((recv (enc b (invk a))) (send (enc a (invk b))))
    ((send (enc b (invk a)))))
  (label 26)
  (parent 24)
  (seen 20)
  (unrealized)
  (comment "1 in cohort - 0 not yet seen"))

(comment "Nothing left to do")
