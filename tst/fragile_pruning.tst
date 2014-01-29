(comment "CPSA 2.3.3")
(comment "All input read from fragile_pruning.scm")

(defprotocol fragile_pruning basic
  (defrole init
    (vars (k akey) (n n1 n2 n3 text))
    (trace (send (enc n k)) (recv (enc n n1 k)) (recv (enc n n2 k))
      (recv (enc n n3 k)) (send (enc n n1 n2 n3 k))
      (recv (enc n n1 n2 n3 n k)))
    (non-orig (invk k))
    (uniq-orig n))
  (defrole adder
    (vars (k akey) (n new text))
    (trace (recv (enc n k)) (send (enc n new k)))
    (uniq-orig new))
  (defrole final
    (vars (k akey) (n n1 n2 n3 text))
    (trace (recv (enc n n1 n2 n3 k)) (send (enc n n1 n2 n3 n k)))))

(defskeleton fragile_pruning
  (vars (n n1 n2 n3 text) (k akey))
  (defstrand init 6 (n n) (n1 n1) (n2 n2) (n3 n3) (k k))
  (non-orig (invk k))
  (uniq-orig n n1 n2 n3)
  (traces
    ((send (enc n k)) (recv (enc n n1 k)) (recv (enc n n2 k))
      (recv (enc n n3 k)) (send (enc n n1 n2 n3 k))
      (recv (enc n n1 n2 n3 n k))))
  (label 0)
  (unrealized (0 1) (0 2) (0 3) (0 5))
  (origs (n (0 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton fragile_pruning
  (vars (n n1 n2 n3 new text) (k akey))
  (defstrand init 6 (n n) (n1 n1) (n2 n2) (n3 n3) (k k))
  (defstrand adder 2 (n n) (new new) (k k))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk k))
  (uniq-orig n n1 n2 n3 new)
  (operation nonce-test (added-strand adder 2) n (0 1) (enc n k))
  (traces
    ((send (enc n k)) (recv (enc n n1 k)) (recv (enc n n2 k))
      (recv (enc n n3 k)) (send (enc n n1 n2 n3 k))
      (recv (enc n n1 n2 n3 n k)))
    ((recv (enc n k)) (send (enc n new k))))
  (label 1)
  (parent 0)
  (unrealized (0 1) (0 2) (0 3) (0 5))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton fragile_pruning
  (vars (n n2 n3 new text) (k akey))
  (defstrand init 6 (n n) (n1 new) (n2 n2) (n3 n3) (k k))
  (defstrand adder 2 (n n) (new new) (k k))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk k))
  (uniq-orig n n2 n3 new)
  (operation nonce-test (contracted (n1 new)) n (0 1) (enc n k)
    (enc n new k))
  (traces
    ((send (enc n k)) (recv (enc n new k)) (recv (enc n n2 k))
      (recv (enc n n3 k)) (send (enc n new n2 n3 k))
      (recv (enc n new n2 n3 n k)))
    ((recv (enc n k)) (send (enc n new k))))
  (label 2)
  (parent 1)
  (unrealized (0 2) (0 3) (0 5))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton fragile_pruning
  (vars (n n3 new text) (k akey))
  (defstrand init 6 (n n) (n1 new) (n2 new) (n3 n3) (k k))
  (defstrand adder 2 (n n) (new new) (k k))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk k))
  (uniq-orig n n3 new)
  (operation nonce-test (contracted (n2 new)) n (0 2) (enc n k)
    (enc n new k))
  (traces
    ((send (enc n k)) (recv (enc n new k)) (recv (enc n new k))
      (recv (enc n n3 k)) (send (enc n new new n3 k))
      (recv (enc n new new n3 n k)))
    ((recv (enc n k)) (send (enc n new k))))
  (label 3)
  (parent 2)
  (unrealized (0 3) (0 5))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton fragile_pruning
  (vars (n new text) (k akey))
  (defstrand init 6 (n n) (n1 new) (n2 new) (n3 new) (k k))
  (defstrand adder 2 (n n) (new new) (k k))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk k))
  (uniq-orig n new)
  (operation nonce-test (contracted (n3 new)) n (0 3) (enc n k)
    (enc n new k))
  (traces
    ((send (enc n k)) (recv (enc n new k)) (recv (enc n new k))
      (recv (enc n new k)) (send (enc n new new new k))
      (recv (enc n new new new n k)))
    ((recv (enc n k)) (send (enc n new k))))
  (label 4)
  (parent 3)
  (unrealized (0 5))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton fragile_pruning
  (vars (n new text) (k akey))
  (defstrand init 6 (n n) (n1 new) (n2 new) (n3 new) (k k))
  (defstrand adder 2 (n n) (new new) (k k))
  (defstrand final 2 (n n) (n1 new) (n2 new) (n3 new) (k k))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)) ((1 1) (2 0)) ((2 1) (0 5)))
  (non-orig (invk k))
  (uniq-orig n new)
  (operation nonce-test (added-strand final 2) n (0 5) (enc n k)
    (enc n new k) (enc n new new new k))
  (traces
    ((send (enc n k)) (recv (enc n new k)) (recv (enc n new k))
      (recv (enc n new k)) (send (enc n new new new k))
      (recv (enc n new new new n k)))
    ((recv (enc n k)) (send (enc n new k)))
    ((recv (enc n new new new k)) (send (enc n new new new n k))))
  (label 5)
  (parent 4)
  (unrealized (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton fragile_pruning
  (vars (n new text) (k akey))
  (defstrand init 6 (n n) (n1 new) (n2 new) (n3 new) (k k))
  (defstrand adder 2 (n n) (new new) (k k))
  (defstrand final 2 (n n) (n1 new) (n2 new) (n3 new) (k k))
  (precedes ((0 0) (1 0)) ((0 4) (2 0)) ((1 1) (0 1)) ((2 1) (0 5)))
  (non-orig (invk k))
  (uniq-orig n new)
  (operation nonce-test (displaced 3 0 init 5) n (2 0) (enc n k)
    (enc n new k))
  (traces
    ((send (enc n k)) (recv (enc n new k)) (recv (enc n new k))
      (recv (enc n new k)) (send (enc n new new new k))
      (recv (enc n new new new n k)))
    ((recv (enc n k)) (send (enc n new k)))
    ((recv (enc n new new new k)) (send (enc n new new new n k))))
  (label 6)
  (parent 5)
  (unrealized)
  (shape)
  (maps ((0) ((k k) (n n) (n1 new) (n2 new) (n3 new))))
  (origs (n (0 0)) (new (1 1))))

(comment "Nothing left to do")
