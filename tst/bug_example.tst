(herald bug_example (bound 10))

(comment "CPSA 4.0.0")
(comment "All input read from bug_example.scm")
(comment "Strand count bounded at 10")

(defprotocol bug_example basic
  (defrole init
    (vars (x y akey))
    (trace (send (enc y (hash x (invk y)))))
    (non-orig (invk x) (invk y)))
  (defrole resp
    (vars (x y akey))
    (trace (recv (enc y (hash (invk x) y))))
    (non-orig (invk x) (invk y)))
  (defrole flip
    (vars (k k1 k2 akey))
    (trace (recv (enc k (hash k1 k2)))
      (send (enc k (hash (invk k1) (invk k2)))))))

(defskeleton bug_example
  (vars (x y akey))
  (defstrand resp 1 (x x) (y y))
  (non-orig (invk x) (invk y))
  (traces ((recv (enc y (hash (invk x) y)))))
  (label 0)
  (unrealized (0 0))
  (origs)
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton bug_example
  (vars (x k2 akey))
  (defstrand resp 1 (x x) (y (invk k2)))
  (defstrand flip 2 (k (invk k2)) (k1 x) (k2 k2))
  (precedes ((1 1) (0 0)))
  (non-orig k2 (invk x))
  (operation encryption-test (added-strand flip 2)
    (enc (invk k2) (hash (invk x) (invk k2))) (0 0))
  (traces ((recv (enc (invk k2) (hash (invk x) (invk k2)))))
    ((recv (enc (invk k2) (hash x k2)))
      (send (enc (invk k2) (hash (invk x) (invk k2))))))
  (label 1)
  (parent 0)
  (unrealized (1 0))
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton bug_example
  (vars (x y akey))
  (defstrand resp 1 (x x) (y y))
  (deflistener (hash (invk x) y))
  (precedes ((1 1) (0 0)))
  (non-orig (invk x) (invk y))
  (operation encryption-test (added-listener (hash (invk x) y))
    (enc y (hash (invk x) y)) (0 0))
  (traces ((recv (enc y (hash (invk x) y))))
    ((recv (hash (invk x) y)) (send (hash (invk x) y))))
  (label 2)
  (parent 0)
  (unrealized (1 0))
  (comment "empty cohort"))

(defskeleton bug_example
  (vars (x k2 akey))
  (defstrand resp 1 (x x) (y (invk k2)))
  (defstrand flip 2 (k (invk k2)) (k1 x) (k2 k2))
  (defstrand init 1 (x x) (y (invk k2)))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)))
  (non-orig k2 (invk x))
  (operation encryption-test (added-strand init 1)
    (enc (invk k2) (hash x k2)) (1 0))
  (traces ((recv (enc (invk k2) (hash (invk x) (invk k2)))))
    ((recv (enc (invk k2) (hash x k2)))
      (send (enc (invk k2) (hash (invk x) (invk k2)))))
    ((send (enc (invk k2) (hash x k2)))))
  (label 3)
  (parent 1)
  (unrealized)
  (shape)
  (maps ((0) ((x x) (y (invk k2)))))
  (origs))

(defskeleton bug_example
  (vars (k1 k2 akey))
  (defstrand resp 1 (x (invk k1)) (y k2))
  (defstrand flip 2 (k k2) (k1 (invk k1)) (k2 (invk k2)))
  (defstrand flip 2 (k k2) (k1 k1) (k2 k2))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)))
  (non-orig k1 (invk k2))
  (operation encryption-test (added-strand flip 2)
    (enc k2 (hash (invk k1) (invk k2))) (1 0))
  (traces ((recv (enc k2 (hash k1 k2))))
    ((recv (enc k2 (hash (invk k1) (invk k2))))
      (send (enc k2 (hash k1 k2))))
    ((recv (enc k2 (hash k1 k2)))
      (send (enc k2 (hash (invk k1) (invk k2))))))
  (label 4)
  (parent 1)
  (unrealized (2 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton bug_example
  (vars (x k2 akey))
  (defstrand resp 1 (x x) (y (invk k2)))
  (defstrand flip 2 (k (invk k2)) (k1 x) (k2 k2))
  (deflistener (hash x k2))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)))
  (non-orig k2 (invk x))
  (operation encryption-test (added-listener (hash x k2))
    (enc (invk k2) (hash x k2)) (1 0))
  (traces ((recv (enc (invk k2) (hash (invk x) (invk k2)))))
    ((recv (enc (invk k2) (hash x k2)))
      (send (enc (invk k2) (hash (invk x) (invk k2)))))
    ((recv (hash x k2)) (send (hash x k2))))
  (label 5)
  (parent 1)
  (unrealized (2 0))
  (comment "empty cohort"))

(defskeleton bug_example
  (vars (k1 k2 akey))
  (defstrand resp 1 (x k1) (y (invk k2)))
  (defstrand flip 2 (k (invk k2)) (k1 k1) (k2 k2))
  (defstrand flip 2 (k (invk k2)) (k1 (invk k1)) (k2 (invk k2)))
  (defstrand flip 2 (k (invk k2)) (k1 k1) (k2 k2))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)) ((3 1) (2 0)))
  (non-orig k2 (invk k1))
  (operation encryption-test (added-strand flip 2)
    (enc (invk k2) (hash (invk k1) (invk k2))) (2 0))
  (traces ((recv (enc (invk k2) (hash (invk k1) (invk k2)))))
    ((recv (enc (invk k2) (hash k1 k2)))
      (send (enc (invk k2) (hash (invk k1) (invk k2)))))
    ((recv (enc (invk k2) (hash (invk k1) (invk k2))))
      (send (enc (invk k2) (hash k1 k2))))
    ((recv (enc (invk k2) (hash k1 k2)))
      (send (enc (invk k2) (hash (invk k1) (invk k2))))))
  (label 6)
  (parent 4)
  (seen 4)
  (unrealized (3 0))
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton bug_example
  (vars (k1 k2 akey))
  (defstrand resp 1 (x (invk k1)) (y k2))
  (defstrand flip 2 (k k2) (k1 (invk k1)) (k2 (invk k2)))
  (defstrand flip 2 (k k2) (k1 k1) (k2 k2))
  (deflistener (hash k1 k2))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)) ((3 1) (2 0)))
  (non-orig k1 (invk k2))
  (operation encryption-test (added-listener (hash k1 k2))
    (enc k2 (hash k1 k2)) (2 0))
  (traces ((recv (enc k2 (hash k1 k2))))
    ((recv (enc k2 (hash (invk k1) (invk k2))))
      (send (enc k2 (hash k1 k2))))
    ((recv (enc k2 (hash k1 k2)))
      (send (enc k2 (hash (invk k1) (invk k2)))))
    ((recv (hash k1 k2)) (send (hash k1 k2))))
  (label 7)
  (parent 4)
  (unrealized (3 0))
  (comment "empty cohort"))

(comment "Nothing left to do")

(defprotocol bug_example basic
  (defrole init
    (vars (x y akey))
    (trace (send (enc y (hash x (invk y)))))
    (non-orig (invk x) (invk y)))
  (defrole resp
    (vars (x y akey))
    (trace (recv (enc y (hash (invk x) y))))
    (non-orig (invk x) (invk y)))
  (defrole flip1
    (vars (k k1 k2 akey))
    (trace (recv (enc k (hash (invk k1) k2)))
      (send (enc k (hash k1 (invk k2))))))
  (defrole flip2
    (vars (k k1 k2 akey))
    (trace (recv (enc k (hash k1 (invk k2))))
      (send (enc k (hash (invk k1) k2))))))

(defskeleton bug_example
  (vars (x y akey))
  (defstrand resp 1 (x x) (y y))
  (non-orig (invk x) (invk y))
  (traces ((recv (enc y (hash (invk x) y)))))
  (label 8)
  (unrealized (0 0))
  (origs)
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton bug_example
  (vars (x y akey))
  (defstrand resp 1 (x x) (y y))
  (defstrand flip2 2 (k y) (k1 x) (k2 y))
  (precedes ((1 1) (0 0)))
  (non-orig (invk x) (invk y))
  (operation encryption-test (added-strand flip2 2)
    (enc y (hash (invk x) y)) (0 0))
  (traces ((recv (enc y (hash (invk x) y))))
    ((recv (enc y (hash x (invk y)))) (send (enc y (hash (invk x) y)))))
  (label 9)
  (parent 8)
  (unrealized (1 0))
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton bug_example
  (vars (x y akey))
  (defstrand resp 1 (x x) (y y))
  (deflistener (hash (invk x) y))
  (precedes ((1 1) (0 0)))
  (non-orig (invk x) (invk y))
  (operation encryption-test (added-listener (hash (invk x) y))
    (enc y (hash (invk x) y)) (0 0))
  (traces ((recv (enc y (hash (invk x) y))))
    ((recv (hash (invk x) y)) (send (hash (invk x) y))))
  (label 10)
  (parent 8)
  (unrealized (1 0))
  (comment "empty cohort"))

(defskeleton bug_example
  (vars (x y akey))
  (defstrand resp 1 (x x) (y y))
  (defstrand flip2 2 (k y) (k1 x) (k2 y))
  (defstrand init 1 (x x) (y y))
  (precedes ((1 1) (0 0)) ((2 0) (1 0)))
  (non-orig (invk x) (invk y))
  (operation encryption-test (added-strand init 1)
    (enc y (hash x (invk y))) (1 0))
  (traces ((recv (enc y (hash (invk x) y))))
    ((recv (enc y (hash x (invk y)))) (send (enc y (hash (invk x) y))))
    ((send (enc y (hash x (invk y))))))
  (label 11)
  (parent 9)
  (unrealized)
  (shape)
  (maps ((0) ((x x) (y y))))
  (origs))

(defskeleton bug_example
  (vars (y k1 akey))
  (defstrand resp 1 (x (invk k1)) (y y))
  (defstrand flip2 2 (k y) (k1 (invk k1)) (k2 y))
  (defstrand flip2 2 (k y) (k1 k1) (k2 (invk y)))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)))
  (non-orig k1 (invk y))
  (operation encryption-test (added-strand flip2 2)
    (enc y (hash (invk k1) (invk y))) (1 0))
  (traces ((recv (enc y (hash k1 y))))
    ((recv (enc y (hash (invk k1) (invk y))))
      (send (enc y (hash k1 y))))
    ((recv (enc y (hash k1 y)))
      (send (enc y (hash (invk k1) (invk y))))))
  (label 12)
  (parent 9)
  (unrealized (2 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton bug_example
  (vars (x y akey))
  (defstrand resp 1 (x x) (y y))
  (defstrand flip2 2 (k y) (k1 x) (k2 y))
  (deflistener (hash x (invk y)))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)))
  (non-orig (invk x) (invk y))
  (operation encryption-test (added-listener (hash x (invk y)))
    (enc y (hash x (invk y))) (1 0))
  (traces ((recv (enc y (hash (invk x) y))))
    ((recv (enc y (hash x (invk y)))) (send (enc y (hash (invk x) y))))
    ((recv (hash x (invk y))) (send (hash x (invk y)))))
  (label 13)
  (parent 9)
  (unrealized (2 0))
  (comment "empty cohort"))

(defskeleton bug_example
  (vars (y k1 akey))
  (defstrand resp 1 (x k1) (y y))
  (defstrand flip2 2 (k y) (k1 k1) (k2 y))
  (defstrand flip2 2 (k y) (k1 (invk k1)) (k2 (invk y)))
  (defstrand flip2 2 (k y) (k1 k1) (k2 y))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)) ((3 1) (2 0)))
  (non-orig (invk y) (invk k1))
  (operation encryption-test (added-strand flip2 2)
    (enc y (hash (invk k1) y)) (2 0))
  (traces ((recv (enc y (hash (invk k1) y))))
    ((recv (enc y (hash k1 (invk y))))
      (send (enc y (hash (invk k1) y))))
    ((recv (enc y (hash (invk k1) y)))
      (send (enc y (hash k1 (invk y)))))
    ((recv (enc y (hash k1 (invk y))))
      (send (enc y (hash (invk k1) y)))))
  (label 14)
  (parent 12)
  (seen 12)
  (unrealized (3 0))
  (comment "1 in cohort - 0 not yet seen"))

(defskeleton bug_example
  (vars (y k1 akey))
  (defstrand resp 1 (x (invk k1)) (y y))
  (defstrand flip2 2 (k y) (k1 (invk k1)) (k2 y))
  (defstrand flip2 2 (k y) (k1 k1) (k2 (invk y)))
  (deflistener (hash k1 y))
  (precedes ((1 1) (0 0)) ((2 1) (1 0)) ((3 1) (2 0)))
  (non-orig k1 (invk y))
  (operation encryption-test (added-listener (hash k1 y))
    (enc y (hash k1 y)) (2 0))
  (traces ((recv (enc y (hash k1 y))))
    ((recv (enc y (hash (invk k1) (invk y))))
      (send (enc y (hash k1 y))))
    ((recv (enc y (hash k1 y)))
      (send (enc y (hash (invk k1) (invk y)))))
    ((recv (hash k1 y)) (send (hash k1 y))))
  (label 15)
  (parent 12)
  (unrealized (3 0))
  (comment "empty cohort"))

(comment "Nothing left to do")
