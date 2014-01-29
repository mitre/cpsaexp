(comment "CPSA 2.3.3")
(comment "All input read from uncarried_keys.scm")

(defprotocol uncarried-keys basic
  (defrole init
    (vars (a text) (A B name) (K akey))
    (trace (send (enc "start" a A B (pubk B)))
      (recv (enc a A B (pubk A))) (send (enc a K (pubk B)))
      (recv (enc a A B K)))
    (non-orig (invk K) (privk B))
    (uniq-orig a K))
  (defrole resp
    (vars (a text) (A B name) (K akey))
    (trace (recv (enc "start" a A B (pubk B)))
      (send (enc a A B (pubk A))) (recv (enc a K (pubk B)))
      (send (enc a A B K)))))

(defskeleton uncarried-keys
  (vars (a text) (A B name) (K akey))
  (defstrand init 4 (a a) (A A) (B B) (K K))
  (non-orig (invk K) (privk B))
  (uniq-orig a K)
  (traces
    ((send (enc "start" a A B (pubk B))) (recv (enc a A B (pubk A)))
      (send (enc a K (pubk B))) (recv (enc a A B K))))
  (label 0)
  (unrealized (0 1) (0 3))
  (origs (K (0 2)) (a (0 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton uncarried-keys
  (vars (a text) (A B name) (K akey))
  (defstrand init 4 (a a) (A A) (B B) (K K))
  (defstrand resp 2 (a a) (A A) (B B))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk K) (privk B))
  (uniq-orig a K)
  (operation nonce-test (added-strand resp 2) a (0 1)
    (enc "start" a A B (pubk B)))
  (traces
    ((send (enc "start" a A B (pubk B))) (recv (enc a A B (pubk A)))
      (send (enc a K (pubk B))) (recv (enc a A B K)))
    ((recv (enc "start" a A B (pubk B))) (send (enc a A B (pubk A)))))
  (label 1)
  (parent 0)
  (unrealized (0 3))
  (comment "4 in cohort - 4 not yet seen"))

(defskeleton uncarried-keys
  (vars (a text) (A B name) (K akey))
  (defstrand init 4 (a a) (A A) (B B) (K K))
  (defstrand resp 4 (a a) (A A) (B B) (K K))
  (precedes ((0 0) (1 0)) ((0 2) (1 2)) ((1 1) (0 1)) ((1 3) (0 3)))
  (non-orig (invk K) (privk B))
  (uniq-orig a K)
  (operation encryption-test (displaced 1 2 resp 4) (enc a A B K) (0 3))
  (traces
    ((send (enc "start" a A B (pubk B))) (recv (enc a A B (pubk A)))
      (send (enc a K (pubk B))) (recv (enc a A B K)))
    ((recv (enc "start" a A B (pubk B))) (send (enc a A B (pubk A)))
      (recv (enc a K (pubk B))) (send (enc a A B K))))
  (label 2)
  (parent 1)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (A A) (B B) (K K))))
  (origs (K (0 2)) (a (0 0))))

(defskeleton uncarried-keys
  (vars (a text) (A B name) (K akey))
  (defstrand init 4 (a a) (A A) (B B) (K K))
  (defstrand resp 2 (a a) (A A) (B B))
  (defstrand resp 4 (a a) (A A) (B B) (K K))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((0 2) (2 2)) ((1 1) (0 1))
    ((2 3) (0 3)))
  (non-orig (invk K) (privk B))
  (uniq-orig a K)
  (operation encryption-test (added-strand resp 4) (enc a A B K) (0 3))
  (traces
    ((send (enc "start" a A B (pubk B))) (recv (enc a A B (pubk A)))
      (send (enc a K (pubk B))) (recv (enc a A B K)))
    ((recv (enc "start" a A B (pubk B))) (send (enc a A B (pubk A))))
    ((recv (enc "start" a A B (pubk B))) (send (enc a A B (pubk A)))
      (recv (enc a K (pubk B))) (send (enc a A B K))))
  (label 3)
  (parent 1)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (A A) (B B) (K K))))
  (origs (K (0 2)) (a (0 0))))

(defskeleton uncarried-keys
  (vars (a text) (A B name))
  (defstrand init 4 (a a) (A A) (B B) (K (pubk A)))
  (defstrand resp 2 (a a) (A A) (B B))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk A) (privk B))
  (uniq-orig a (pubk A))
  (operation encryption-test (displaced 2 1 resp 2) (enc a A B (pubk A))
    (0 3))
  (traces
    ((send (enc "start" a A B (pubk B))) (recv (enc a A B (pubk A)))
      (send (enc a (pubk A) (pubk B))) (recv (enc a A B (pubk A))))
    ((recv (enc "start" a A B (pubk B))) (send (enc a A B (pubk A)))))
  (label 4)
  (parent 1)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (A A) (B B) (K (pubk A)))))
  (origs ((pubk A) (0 2)) (a (0 0))))

(defskeleton uncarried-keys
  (vars (a text) (A B name) (K akey))
  (defstrand init 4 (a a) (A A) (B B) (K K))
  (defstrand resp 2 (a a) (A A) (B B))
  (deflistener K)
  (precedes ((0 0) (1 0)) ((0 2) (2 0)) ((1 1) (0 1)) ((2 1) (0 3)))
  (non-orig (invk K) (privk B))
  (uniq-orig a K)
  (operation encryption-test (added-listener K) (enc a A B K) (0 3))
  (traces
    ((send (enc "start" a A B (pubk B))) (recv (enc a A B (pubk A)))
      (send (enc a K (pubk B))) (recv (enc a A B K)))
    ((recv (enc "start" a A B (pubk B))) (send (enc a A B (pubk A))))
    ((recv K) (send K)))
  (label 5)
  (parent 1)
  (unrealized (2 0))
  (comment "empty cohort"))

(comment "Nothing left to do")
