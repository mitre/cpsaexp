(herald "The ffgg Protocol"
  (comment "From A Necessarily Parallel Attack by Jon K. Millen"))

(comment "CPSA 4.0.0")
(comment "All input read from ffgg.scm")

(defprotocol ffgg basic
  (defrole init
    (vars (a b name) (n1 n2 m x y text))
    (trace (send a) (recv (cat b n1 n2))
      (send (cat a (enc n1 n2 m (pubk b))))
      (recv (cat n1 x (enc x y n1 (pubk b))))))
  (defrole resp
    (vars (b a name) (n1 n2 x y text))
    (trace (recv a) (send (cat b n1 n2))
      (recv (cat a (enc n1 x y (pubk b))))
      (send (cat n1 x (enc x y n1 (pubk b)))))
    (uniq-orig n1 n2)))

(defskeleton ffgg
  (vars (m n1 n2 x y text) (b a name))
  (defstrand init 4 (n1 n1) (n2 n2) (m m) (x x) (y y) (a a) (b b))
  (deflistener m)
  (non-orig (privk b))
  (uniq-orig m)
  (traces
    ((send a) (recv (cat b n1 n2)) (send (cat a (enc n1 n2 m (pubk b))))
      (recv (cat n1 x (enc x y n1 (pubk b))))) ((recv m) (send m)))
  (label 0)
  (unrealized (1 0))
  (preskeleton)
  (comment "Not a skeleton"))

(defskeleton ffgg
  (vars (m n1 n2 x y text) (b a name))
  (defstrand init 4 (n1 n1) (n2 n2) (m m) (x x) (y y) (a a) (b b))
  (deflistener m)
  (precedes ((0 2) (1 0)))
  (non-orig (privk b))
  (uniq-orig m)
  (traces
    ((send a) (recv (cat b n1 n2)) (send (cat a (enc n1 n2 m (pubk b))))
      (recv (cat n1 x (enc x y n1 (pubk b))))) ((recv m) (send m)))
  (label 1)
  (parent 0)
  (unrealized (1 0))
  (origs (m (0 2)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton ffgg
  (vars (m n1 n2 x y n2-0 text) (b a a-0 name))
  (defstrand init 4 (n1 n1) (n2 n2) (m m) (x x) (y y) (a a) (b b))
  (deflistener m)
  (defstrand resp 4 (n1 n1) (n2 n2-0) (x n2) (y m) (b b) (a a-0))
  (precedes ((0 2) (2 2)) ((2 1) (0 1)) ((2 3) (1 0)))
  (non-orig (privk b))
  (uniq-orig m n1 n2-0)
  (operation nonce-test (added-strand resp 4) m (1 0)
    (enc n1 n2 m (pubk b)))
  (traces
    ((send a) (recv (cat b n1 n2)) (send (cat a (enc n1 n2 m (pubk b))))
      (recv (cat n1 x (enc x y n1 (pubk b))))) ((recv m) (send m))
    ((recv a-0) (send (cat b n1 n2-0))
      (recv (cat a-0 (enc n1 n2 m (pubk b))))
      (send (cat n1 n2 (enc n2 m n1 (pubk b))))))
  (label 2)
  (parent 1)
  (unrealized (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton ffgg
  (vars (m n1 n2 x y n2-0 n2-1 text) (b a a-0 a-1 name))
  (defstrand init 4 (n1 n1) (n2 n2) (m m) (x x) (y y) (a a) (b b))
  (deflistener m)
  (defstrand resp 4 (n1 n1) (n2 n2-0) (x n2) (y m) (b b) (a a-0))
  (defstrand resp 4 (n1 n2) (n2 n2-1) (x m) (y n1) (b b) (a a-1))
  (precedes ((0 2) (2 2)) ((0 2) (3 2)) ((2 1) (0 1)) ((2 3) (1 0))
    ((3 1) (0 1)) ((3 3) (1 0)))
  (non-orig (privk b))
  (uniq-orig m n1 n2 n2-0 n2-1)
  (operation nonce-test (added-strand resp 4) m (1 0)
    (enc n1 n2 m (pubk b)) (enc n2 m n1 (pubk b)))
  (traces
    ((send a) (recv (cat b n1 n2)) (send (cat a (enc n1 n2 m (pubk b))))
      (recv (cat n1 x (enc x y n1 (pubk b))))) ((recv m) (send m))
    ((recv a-0) (send (cat b n1 n2-0))
      (recv (cat a-0 (enc n1 n2 m (pubk b))))
      (send (cat n1 n2 (enc n2 m n1 (pubk b)))))
    ((recv a-1) (send (cat b n2 n2-1))
      (recv (cat a-1 (enc n2 m n1 (pubk b))))
      (send (cat n2 m (enc m n1 n2 (pubk b))))))
  (label 3)
  (parent 2)
  (unrealized (3 2))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton ffgg
  (vars (m n1 n2 x y n2-0 n2-1 text) (b a a-0 a-1 name))
  (defstrand init 4 (n1 n1) (n2 n2) (m m) (x x) (y y) (a a) (b b))
  (deflistener m)
  (defstrand resp 4 (n1 n1) (n2 n2-0) (x n2) (y m) (b b) (a a-0))
  (defstrand resp 4 (n1 n2) (n2 n2-1) (x m) (y n1) (b b) (a a-1))
  (precedes ((0 2) (2 2)) ((2 1) (0 1)) ((2 3) (3 2)) ((3 1) (0 1))
    ((3 3) (1 0)))
  (non-orig (privk b))
  (uniq-orig m n1 n2 n2-0 n2-1)
  (operation nonce-test (displaced 4 2 resp 4) m (3 2)
    (enc n1 n2 m (pubk b)))
  (traces
    ((send a) (recv (cat b n1 n2)) (send (cat a (enc n1 n2 m (pubk b))))
      (recv (cat n1 x (enc x y n1 (pubk b))))) ((recv m) (send m))
    ((recv a-0) (send (cat b n1 n2-0))
      (recv (cat a-0 (enc n1 n2 m (pubk b))))
      (send (cat n1 n2 (enc n2 m n1 (pubk b)))))
    ((recv a-1) (send (cat b n2 n2-1))
      (recv (cat a-1 (enc n2 m n1 (pubk b))))
      (send (cat n2 m (enc m n1 n2 (pubk b))))))
  (label 4)
  (parent 3)
  (unrealized)
  (shape)
  (maps ((0 1) ((b b) (m m) (a a) (n1 n1) (n2 n2) (x x) (y y))))
  (origs (n1 (2 1)) (n2-0 (2 1)) (n2 (3 1)) (n2-1 (3 1)) (m (0 2))))

(comment "Nothing left to do")
