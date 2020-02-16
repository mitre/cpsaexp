(herald "Needham-Schroeder Public-Key Protocol This-That Variant")

(comment "CPSA 4.2.3")
(comment "All input read from tst/thisthat.scm")

(defprotocol thisthat basic
  (defrole init
    (vars (a b name) (n1 n2 n3 text))
    (trace (send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n2 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n2 (pubk b)) (enc "that" n3 (pubk b))))))
  (defrole this
    (vars (b a name) (n2 n1 text))
    (trace (recv (enc n1 a (pubk b))) (send (enc n1 n2 (pubk a)))
      (send (enc "this" n2 (pubk b))))
    (uniq-orig n2))
  (defrole that
    (vars (b a name) (n3 n1 text))
    (trace (recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "that" n3 (pubk b))))
    (uniq-orig n3)))

(defskeleton thisthat
  (vars (n1 n2 n3 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n2) (n3 n3) (a a) (b b))
  (non-orig (privk a) (privk b))
  (uniq-orig n1)
  (comment "Initiator point-of-view")
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n2 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n2 (pubk b)) (enc "that" n3 (pubk b))))))
  (label 0)
  (unrealized (0 1))
  (origs (n1 (0 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton thisthat
  (vars (n1 n2 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n2) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3-0) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3-0)
  (operation nonce-test (added-strand that 2) n1 (0 1)
    (enc n1 a (pubk b)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n2 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n2 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a)))))
  (label 1)
  (parent 0)
  (unrealized (0 1))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton thisthat
  (vars (n1 n2 n3 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n2) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3)
  (operation nonce-test (contracted (n3-0 n3)) n1 (0 1)
    (enc n1 n3 (pubk a)) (enc n1 a (pubk b)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n2 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n2 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))))
  (label 2)
  (parent 1)
  (unrealized (0 1) (0 2))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton thisthat
  (vars (n1 n3 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3)
  (operation nonce-test (contracted (n2 n3)) n1 (0 1)
    (enc n1 n3 (pubk a)) (enc n1 a (pubk b)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))))
  (label 3)
  (parent 2)
  (unrealized (0 2))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton thisthat
  (vars (n1 n2 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n2) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3) (n1 n1) (b b) (a a))
  (defstrand that 2 (n3 n3-0) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((2 1) (0 1)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (added-strand that 2) n1 (0 1)
    (enc n1 n3 (pubk a)) (enc n1 a (pubk b)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n2 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n2 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a)))))
  (label 4)
  (parent 2)
  (unrealized (0 1) (0 2))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton thisthat
  (vars (n1 n3 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3) (n3 n3) (a a) (b b))
  (defstrand this 3 (n2 n3) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)) ((1 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3)
  (operation nonce-test (displaced 1 2 this 3) n3 (0 2)
    (enc n1 n3 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "this" n3 (pubk b)))))
  (label 5)
  (parent 3)
  (unrealized (0 2))
  (dead)
  (comment "empty cohort"))

(defskeleton thisthat
  (vars (n1 n3 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3) (n3 n3) (a a) (b b))
  (defstrand that 3 (n3 n3) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)) ((1 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3)
  (operation nonce-test (displaced 1 2 that 3) n3 (0 2)
    (enc n1 n3 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "that" n3 (pubk b)))))
  (label 6)
  (parent 3)
  (unrealized (0 2))
  (dead)
  (comment "empty cohort"))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3) (n1 n1) (b b) (a a))
  (defstrand that 2 (n3 n3-0) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((2 1) (0 1)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (contracted (n2 n3)) n1 (0 1)
    (enc n1 n3 (pubk a)) (enc n1 n3-0 (pubk a)) (enc n1 a (pubk b)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a)))))
  (label 7)
  (parent 4)
  (unrealized (0 2))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3-0) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3) (n1 n1) (b b) (a a))
  (defstrand that 2 (n3 n3-0) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((2 1) (0 1)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (contracted (n2 n3-0)) n1 (0 1)
    (enc n1 n3 (pubk a)) (enc n1 n3-0 (pubk a)) (enc n1 a (pubk b)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3-0 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3-0 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a)))))
  (label 8)
  (parent 4)
  (unrealized (0 2))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3-0) (n1 n1) (b b) (a a))
  (defstrand this 3 (n2 n3) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((2 1) (0 1))
    ((2 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (displaced 1 3 this 3) n3 (0 2)
    (enc n1 n3 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "this" n3 (pubk b)))))
  (label 9)
  (parent 7)
  (unrealized (0 2))
  (dead)
  (comment "empty cohort"))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3-0) (n1 n1) (b b) (a a))
  (defstrand that 3 (n3 n3) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((2 1) (0 1))
    ((2 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (displaced 1 3 that 3) n3 (0 2)
    (enc n1 n3 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "that" n3 (pubk b)))))
  (label 10)
  (parent 7)
  (unrealized (0 2))
  (dead)
  (comment "empty cohort"))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3-0) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3-0) (n1 n1) (b b) (a a))
  (defstrand this 3 (n2 n3) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((2 1) (0 1))
    ((2 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (displaced 1 3 this 3) n3 (0 2)
    (enc n1 n3 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3-0 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3-0 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "this" n3 (pubk b)))))
  (label 11)
  (parent 8)
  (unrealized (0 2))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3-0) (n3 n3) (a a) (b b))
  (defstrand that 2 (n3 n3-0) (n1 n1) (b b) (a a))
  (defstrand that 3 (n3 n3) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((2 1) (0 1))
    ((2 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (displaced 1 3 that 3) n3 (0 2)
    (enc n1 n3 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3-0 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3-0 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "that" n3 (pubk b)))))
  (label 12)
  (parent 8)
  (unrealized (0 2))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3-0) (n3 n3) (a a) (b b))
  (defstrand this 3 (n2 n3) (n1 n1) (b b) (a a))
  (defstrand this 3 (n2 n3-0) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((1 2) (0 2))
    ((2 1) (0 1)) ((2 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (displaced 1 3 this 3) n3-0 (0 2)
    (enc n1 n3-0 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3-0 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3-0 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "this" n3 (pubk b))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a)))
      (send (enc "this" n3-0 (pubk b)))))
  (label 13)
  (parent 11)
  (unrealized (0 2))
  (dead)
  (comment "empty cohort"))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3-0) (n3 n3) (a a) (b b))
  (defstrand this 3 (n2 n3) (n1 n1) (b b) (a a))
  (defstrand that 3 (n3 n3-0) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((1 2) (0 2))
    ((2 1) (0 1)) ((2 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (displaced 1 3 that 3) n3-0 (0 2)
    (enc n1 n3-0 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3-0 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3-0 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "this" n3 (pubk b))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a)))
      (send (enc "that" n3-0 (pubk b)))))
  (label 14)
  (parent 11)
  (unrealized (0 2))
  (dead)
  (comment "empty cohort"))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3-0) (n3 n3) (a a) (b b))
  (defstrand that 3 (n3 n3) (n1 n1) (b b) (a a))
  (defstrand this 3 (n2 n3-0) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((1 2) (0 2))
    ((2 1) (0 1)) ((2 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (displaced 1 3 this 3) n3-0 (0 2)
    (enc n1 n3-0 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3-0 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3-0 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "that" n3 (pubk b))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a)))
      (send (enc "this" n3-0 (pubk b)))))
  (label 15)
  (parent 12)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (n1 n1) (n2 n3-0) (n3 n3))))
  (origs (n3-0 (2 1)) (n3 (1 1)) (n1 (0 0))))

(defskeleton thisthat
  (vars (n1 n3 n3-0 text) (a b name))
  (defstrand init 3 (n1 n1) (n2 n3-0) (n3 n3) (a a) (b b))
  (defstrand that 3 (n3 n3) (n1 n1) (b b) (a a))
  (defstrand that 3 (n3 n3-0) (n1 n1) (b b) (a a))
  (precedes ((0 0) (1 0)) ((0 0) (2 0)) ((1 1) (0 1)) ((1 2) (0 2))
    ((2 1) (0 1)) ((2 2) (0 2)))
  (non-orig (privk a) (privk b))
  (uniq-orig n1 n3 n3-0)
  (operation nonce-test (displaced 1 3 that 3) n3-0 (0 2)
    (enc n1 n3-0 (pubk a)))
  (traces
    ((send (enc n1 a (pubk b)))
      (recv (cat (enc n1 n3-0 (pubk a)) (enc n1 n3 (pubk a))))
      (recv (cat (enc "this" n3-0 (pubk b)) (enc "that" n3 (pubk b)))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3 (pubk a)))
      (send (enc "that" n3 (pubk b))))
    ((recv (enc n1 a (pubk b))) (send (enc n1 n3-0 (pubk a)))
      (send (enc "that" n3-0 (pubk b)))))
  (label 16)
  (parent 12)
  (unrealized (0 2))
  (dead)
  (comment "empty cohort"))

(comment "Nothing left to do")
