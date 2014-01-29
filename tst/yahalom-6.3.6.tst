(herald "Yahalom Protocol"
  (comment "A Survey of Authentication Protocol Literature:"
    "Version 1.0, John Clark and Jeremy Jacob,"
    "Yahalom Protocol, Section 6.3.6, Page 49")
  (url "http://www.eecs.umich.edu/acal/swerve/docs/49-1.pdf")
  (bound 15))

(comment "CPSA 2.3.3")
(comment "All input read from yahalom-6.3.6.scm")
(comment "Strand count bounded at 15")

(defprotocol yahalom basic
  (defrole init
    (vars (a b s name) (n-a n-b text) (k skey) (blob mesg))
    (trace (send (cat a n-a))
      (recv (cat (enc b k n-a n-b (ltk a s)) blob))
      (send (cat blob (enc n-b k)))))
  (defrole resp
    (vars (a b s name) (n-a n-b text) (k skey))
    (trace (recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k)))))
  (defrole serv
    (vars (a b s name) (n-a n-b text) (k skey))
    (trace (recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    (uniq-orig k))
  (comment "Yahalom protocol, Section 6.3.6, Page 49")
  (url "http://www.eecs.umich.edu/acal/swerve/docs/49-1.pdf"))

(defskeleton yahalom
  (vars (blob mesg) (n-a n-b text) (a b s name) (k skey))
  (defstrand init 3 (blob blob) (n-a n-a) (n-b n-b) (a a) (b b) (s s)
    (k k))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b)
  (traces
    ((send (cat a n-a)) (recv (cat (enc b k n-a n-b (ltk a s)) blob))
      (send (cat blob (enc n-b k)))))
  (label 0)
  (unrealized (0 1))
  (origs (n-a (0 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton yahalom
  (vars (blob mesg) (n-a n-b text) (a b s name) (k skey))
  (defstrand init 3 (blob blob) (n-a n-a) (n-b n-b) (a a) (b b) (s s)
    (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-strand serv 2)
    (enc b k n-a n-b (ltk a s)) (0 1))
  (traces
    ((send (cat a n-a)) (recv (cat (enc b k n-a n-b (ltk a s)) blob))
      (send (cat blob (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s))))))
  (label 1)
  (parent 0)
  (unrealized (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton yahalom
  (vars (blob mesg) (n-a n-b text) (a b s name) (k skey))
  (defstrand init 3 (blob blob) (n-a n-a) (n-b n-b) (a a) (b b) (s s)
    (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand resp 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s))
  (precedes ((0 0) (2 0)) ((1 1) (0 1)) ((2 1) (1 0)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-strand resp 2)
    (enc a n-a n-b (ltk b s)) (1 0))
  (traces
    ((send (cat a n-a)) (recv (cat (enc b k n-a n-b (ltk a s)) blob))
      (send (cat blob (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))))
  (label 2)
  (parent 1)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (s s) (n-a n-a) (n-b n-b) (k k) (blob blob))))
  (origs (k (1 1)) (n-a (0 0)) (n-b (2 1))))

(comment "Nothing left to do")

(defprotocol yahalom basic
  (defrole init
    (vars (a b s name) (n-a n-b text) (k skey) (blob mesg))
    (trace (send (cat a n-a))
      (recv (cat (enc b k n-a n-b (ltk a s)) blob))
      (send (cat blob (enc n-b k)))))
  (defrole resp
    (vars (a b s name) (n-a n-b text) (k skey))
    (trace (recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k)))))
  (defrole serv
    (vars (a b s name) (n-a n-b text) (k skey))
    (trace (recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    (uniq-orig k))
  (comment "Yahalom protocol, Section 6.3.6, Page 49")
  (url "http://www.eecs.umich.edu/acal/swerve/docs/49-1.pdf"))

(defskeleton yahalom
  (vars (n-a n-b text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (deflistener k)
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b)
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k)))) ((recv k) (send k)))
  (label 3)
  (unrealized (0 2))
  (origs (n-b (0 1)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton yahalom
  (vars (n-a n-b n-a-0 n-b-0 text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (deflistener k)
  (defstrand serv 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s) (k k))
  (precedes ((2 1) (0 2)) ((2 1) (1 0)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-strand serv 2) (enc a k (ltk b s))
    (0 2))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k)))) ((recv k) (send k))
    ((recv (cat b (enc a n-a-0 n-b-0 (ltk b s))))
      (send (cat (enc b k n-a-0 n-b-0 (ltk a s)) (enc a k (ltk b s))))))
  (label 4)
  (parent 3)
  (unrealized (0 2) (1 0) (2 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton yahalom
  (vars (n-a n-b text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (deflistener k)
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (precedes ((0 1) (2 0)) ((2 1) (0 2)) ((2 1) (1 0)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (displaced 3 0 resp 2)
    (enc a n-a-0 n-b-0 (ltk b s)) (2 0))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k)))) ((recv k) (send k))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s))))))
  (label 5)
  (parent 4)
  (unrealized (0 2) (1 0))
  (comment "empty cohort"))

(defskeleton yahalom
  (vars (n-a n-b n-a-0 n-b-0 text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (deflistener k)
  (defstrand serv 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s) (k k))
  (defstrand resp 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s))
  (precedes ((2 1) (0 2)) ((2 1) (1 0)) ((3 1) (2 0)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-strand resp 2)
    (enc a n-a-0 n-b-0 (ltk b s)) (2 0))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k)))) ((recv k) (send k))
    ((recv (cat b (enc a n-a-0 n-b-0 (ltk b s))))
      (send (cat (enc b k n-a-0 n-b-0 (ltk a s)) (enc a k (ltk b s)))))
    ((recv (cat a n-a-0)) (send (cat b (enc a n-a-0 n-b-0 (ltk b s))))))
  (label 6)
  (parent 4)
  (unrealized (0 2) (1 0))
  (comment "empty cohort"))

(comment "Nothing left to do")

(defprotocol yahalom basic
  (defrole init
    (vars (a b s name) (n-a n-b text) (k skey) (blob mesg))
    (trace (send (cat a n-a))
      (recv (cat (enc b k n-a n-b (ltk a s)) blob))
      (send (cat blob (enc n-b k)))))
  (defrole resp
    (vars (a b s name) (n-a n-b text) (k skey))
    (trace (recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k)))))
  (defrole serv
    (vars (a b s name) (n-a n-b text) (k skey))
    (trace (recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    (uniq-orig k))
  (comment "Yahalom protocol, Section 6.3.6, Page 49")
  (url "http://www.eecs.umich.edu/acal/swerve/docs/49-1.pdf"))

(defskeleton yahalom
  (vars (n-a n-b text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b)
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k)))))
  (label 7)
  (unrealized (0 2))
  (origs (n-b (0 1)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton yahalom
  (vars (n-a n-b n-a-0 n-b-0 text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s) (k k))
  (precedes ((1 1) (0 2)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-strand serv 2) (enc a k (ltk b s))
    (0 2))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a-0 n-b-0 (ltk b s))))
      (send (cat (enc b k n-a-0 n-b-0 (ltk a s)) (enc a k (ltk b s))))))
  (label 8)
  (parent 7)
  (unrealized (0 2) (1 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton yahalom
  (vars (n-a n-b text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (precedes ((0 1) (1 0)) ((1 1) (0 2)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (displaced 2 0 resp 2)
    (enc a n-a-0 n-b-0 (ltk b s)) (1 0))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s))))))
  (label 9)
  (parent 8)
  (unrealized (0 2))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton yahalom
  (vars (n-a n-b n-a-0 n-b-0 text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s) (k k))
  (defstrand resp 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s))
  (precedes ((1 1) (0 2)) ((2 1) (1 0)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-strand resp 2)
    (enc a n-a-0 n-b-0 (ltk b s)) (1 0))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a-0 n-b-0 (ltk b s))))
      (send (cat (enc b k n-a-0 n-b-0 (ltk a s)) (enc a k (ltk b s)))))
    ((recv (cat a n-a-0)) (send (cat b (enc a n-a-0 n-b-0 (ltk b s))))))
  (label 10)
  (parent 8)
  (unrealized (0 2))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton yahalom
  (vars (blob mesg) (n-a n-b n-a-0 text) (a b s a-0 b-0 s-0 name)
    (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand init 3 (blob blob) (n-a n-a-0) (n-b n-b) (a a-0) (b b-0)
    (s s-0) (k k))
  (precedes ((0 1) (1 0)) ((1 1) (2 1)) ((2 2) (0 2)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-strand init 3) (enc n-b k) (0 2))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    ((send (cat a-0 n-a-0))
      (recv (cat (enc b-0 k n-a-0 n-b (ltk a-0 s-0)) blob))
      (send (cat blob (enc n-b k)))))
  (label 11)
  (parent 9)
  (unrealized (2 1))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton yahalom
  (vars (n-a n-b text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (deflistener k)
  (precedes ((0 1) (1 0)) ((1 1) (2 0)) ((2 1) (0 2)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-listener k) (enc n-b k) (0 2))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    ((recv k) (send k)))
  (label 12)
  (parent 9)
  (unrealized (0 2) (2 0))
  (comment "empty cohort"))

(defskeleton yahalom
  (vars (blob mesg) (n-a n-b n-a-0 n-b-0 n-a-1 text)
    (a b s a-0 b-0 s-0 name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s) (k k))
  (defstrand resp 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s))
  (defstrand init 3 (blob blob) (n-a n-a-1) (n-b n-b) (a a-0) (b b-0)
    (s s-0) (k k))
  (precedes ((0 1) (3 1)) ((1 1) (3 1)) ((2 1) (1 0)) ((3 2) (0 2)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-strand init 3) (enc n-b k) (0 2))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a-0 n-b-0 (ltk b s))))
      (send (cat (enc b k n-a-0 n-b-0 (ltk a s)) (enc a k (ltk b s)))))
    ((recv (cat a n-a-0)) (send (cat b (enc a n-a-0 n-b-0 (ltk b s)))))
    ((send (cat a-0 n-a-1))
      (recv (cat (enc b-0 k n-a-1 n-b (ltk a-0 s-0)) blob))
      (send (cat blob (enc n-b k)))))
  (label 13)
  (parent 10)
  (unrealized (3 1))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton yahalom
  (vars (n-a n-b n-a-0 n-b-0 text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s) (k k))
  (defstrand resp 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s))
  (deflistener k)
  (precedes ((1 1) (3 0)) ((2 1) (1 0)) ((3 1) (0 2)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-listener k) (enc n-b k) (0 2))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a-0 n-b-0 (ltk b s))))
      (send (cat (enc b k n-a-0 n-b-0 (ltk a s)) (enc a k (ltk b s)))))
    ((recv (cat a n-a-0)) (send (cat b (enc a n-a-0 n-b-0 (ltk b s)))))
    ((recv k) (send k)))
  (label 14)
  (parent 10)
  (unrealized (0 2) (3 0))
  (comment "empty cohort"))

(defskeleton yahalom
  (vars (blob mesg) (n-a n-b text) (a b s name) (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand init 3 (blob blob) (n-a n-a) (n-b n-b) (a a) (b b) (s s)
    (k k))
  (precedes ((0 1) (1 0)) ((1 1) (2 1)) ((2 0) (0 0)) ((2 2) (0 2)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation nonce-test (contracted (a-0 a) (b-0 b) (s-0 s) (n-a-0 n-a))
    n-b (2 1) (enc a n-a n-b (ltk b s)) (enc b k n-a n-b (ltk a s)))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    ((send (cat a n-a)) (recv (cat (enc b k n-a n-b (ltk a s)) blob))
      (send (cat blob (enc n-b k)))))
  (label 15)
  (parent 11)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (s s) (n-a n-a) (n-b n-b) (k k))))
  (origs (k (1 1)) (n-a (2 0)) (n-b (0 1))))

(defskeleton yahalom
  (vars (blob blob-0 mesg) (n-a n-b n-a-0 text) (a b s a-0 b-0 s-0 name)
    (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand init 3 (blob blob) (n-a n-a-0) (n-b n-b) (a a-0) (b b-0)
    (s s-0) (k k))
  (defstrand init 3 (blob blob-0) (n-a n-a) (n-b n-b) (a a) (b b) (s s)
    (k k))
  (precedes ((0 1) (1 0)) ((1 1) (3 1)) ((2 2) (0 2)) ((3 0) (0 0))
    ((3 2) (2 1)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation nonce-test (added-strand init 3) n-b (2 1)
    (enc a n-a n-b (ltk b s)) (enc b k n-a n-b (ltk a s)))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    ((send (cat a-0 n-a-0))
      (recv (cat (enc b-0 k n-a-0 n-b (ltk a-0 s-0)) blob))
      (send (cat blob (enc n-b k))))
    ((send (cat a n-a)) (recv (cat (enc b k n-a n-b (ltk a s)) blob-0))
      (send (cat blob-0 (enc n-b k)))))
  (label 16)
  (parent 11)
  (unrealized (2 1))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton yahalom
  (vars (blob mesg) (n-a n-b n-a-0 n-b-0 n-a-1 text)
    (a b s a-0 b-0 s-0 name) (k k-0 skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s) (k k))
  (defstrand resp 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s))
  (defstrand init 3 (blob blob) (n-a n-a-1) (n-b n-b) (a a-0) (b b-0)
    (s s-0) (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k-0))
  (precedes ((0 1) (4 0)) ((1 1) (3 1)) ((2 1) (1 0)) ((3 2) (0 2))
    ((4 1) (3 1)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k k-0)
  (operation nonce-test (added-strand serv 2) n-b (3 1)
    (enc a n-a n-b (ltk b s)))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a-0 n-b-0 (ltk b s))))
      (send (cat (enc b k n-a-0 n-b-0 (ltk a s)) (enc a k (ltk b s)))))
    ((recv (cat a n-a-0)) (send (cat b (enc a n-a-0 n-b-0 (ltk b s)))))
    ((send (cat a-0 n-a-1))
      (recv (cat (enc b-0 k n-a-1 n-b (ltk a-0 s-0)) blob))
      (send (cat blob (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k-0 n-a n-b (ltk a s)) (enc a k-0 (ltk b s))))))
  (label 17)
  (parent 13)
  (unrealized (3 1))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton yahalom
  (vars (blob blob-0 mesg) (n-a n-b n-a-0 text) (a b s a-0 b-0 s-0 name)
    (k skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand init 3 (blob blob) (n-a n-a-0) (n-b n-b) (a a-0) (b b-0)
    (s s-0) (k k))
  (defstrand init 3 (blob blob-0) (n-a n-a) (n-b n-b) (a a) (b b) (s s)
    (k k))
  (deflistener k)
  (precedes ((0 1) (1 0)) ((1 1) (3 1)) ((1 1) (4 0)) ((2 2) (0 2))
    ((3 0) (0 0)) ((3 2) (2 1)) ((4 1) (2 1)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation nonce-test (added-listener k) n-b (2 1) (enc n-b k)
    (enc a n-a n-b (ltk b s)) (enc b k n-a n-b (ltk a s)))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    ((send (cat a-0 n-a-0))
      (recv (cat (enc b-0 k n-a-0 n-b (ltk a-0 s-0)) blob))
      (send (cat blob (enc n-b k))))
    ((send (cat a n-a)) (recv (cat (enc b k n-a n-b (ltk a s)) blob-0))
      (send (cat blob-0 (enc n-b k)))) ((recv k) (send k)))
  (label 18)
  (parent 16)
  (unrealized (4 0))
  (comment "empty cohort"))

(defskeleton yahalom
  (vars (blob blob-0 mesg) (n-a n-b n-a-0 n-b-0 n-a-1 text)
    (a b s a-0 b-0 s-0 name) (k k-0 skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s) (k k))
  (defstrand resp 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s))
  (defstrand init 3 (blob blob) (n-a n-a-1) (n-b n-b) (a a-0) (b b-0)
    (s s-0) (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k-0))
  (defstrand init 3 (blob blob-0) (n-a n-a) (n-b n-b) (a a) (b b) (s s)
    (k k-0))
  (precedes ((0 1) (4 0)) ((1 1) (3 1)) ((2 1) (1 0)) ((3 2) (0 2))
    ((4 1) (5 1)) ((5 0) (0 0)) ((5 2) (3 1)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k k-0)
  (operation nonce-test (added-strand init 3) n-b (3 1)
    (enc a n-a n-b (ltk b s)) (enc b k-0 n-a n-b (ltk a s)))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a-0 n-b-0 (ltk b s))))
      (send (cat (enc b k n-a-0 n-b-0 (ltk a s)) (enc a k (ltk b s)))))
    ((recv (cat a n-a-0)) (send (cat b (enc a n-a-0 n-b-0 (ltk b s)))))
    ((send (cat a-0 n-a-1))
      (recv (cat (enc b-0 k n-a-1 n-b (ltk a-0 s-0)) blob))
      (send (cat blob (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k-0 n-a n-b (ltk a s)) (enc a k-0 (ltk b s)))))
    ((send (cat a n-a))
      (recv (cat (enc b k-0 n-a n-b (ltk a s)) blob-0))
      (send (cat blob-0 (enc n-b k-0)))))
  (label 19)
  (parent 17)
  (unrealized (3 1))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton yahalom
  (vars (blob blob-0 mesg) (n-a n-b n-a-0 n-b-0 n-a-1 text)
    (a b s a-0 b-0 s-0 name) (k k-0 skey))
  (defstrand resp 3 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand serv 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s) (k k))
  (defstrand resp 2 (n-a n-a-0) (n-b n-b-0) (a a) (b b) (s s))
  (defstrand init 3 (blob blob) (n-a n-a-1) (n-b n-b) (a a-0) (b b-0)
    (s s-0) (k k))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k-0))
  (defstrand init 3 (blob blob-0) (n-a n-a) (n-b n-b) (a a) (b b) (s s)
    (k k-0))
  (deflistener k-0)
  (precedes ((0 1) (4 0)) ((1 1) (3 1)) ((2 1) (1 0)) ((3 2) (0 2))
    ((4 1) (5 1)) ((4 1) (6 0)) ((5 0) (0 0)) ((5 2) (3 1))
    ((6 1) (3 1)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k k-0)
  (operation nonce-test (added-listener k-0) n-b (3 1) (enc n-b k-0)
    (enc a n-a n-b (ltk b s)) (enc b k-0 n-a n-b (ltk a s)))
  (traces
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k))))
    ((recv (cat b (enc a n-a-0 n-b-0 (ltk b s))))
      (send (cat (enc b k n-a-0 n-b-0 (ltk a s)) (enc a k (ltk b s)))))
    ((recv (cat a n-a-0)) (send (cat b (enc a n-a-0 n-b-0 (ltk b s)))))
    ((send (cat a-0 n-a-1))
      (recv (cat (enc b-0 k n-a-1 n-b (ltk a-0 s-0)) blob))
      (send (cat blob (enc n-b k))))
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k-0 n-a n-b (ltk a s)) (enc a k-0 (ltk b s)))))
    ((send (cat a n-a))
      (recv (cat (enc b k-0 n-a n-b (ltk a s)) blob-0))
      (send (cat blob-0 (enc n-b k-0)))) ((recv k-0) (send k-0)))
  (label 20)
  (parent 19)
  (unrealized (3 1) (6 0))
  (comment "empty cohort"))

(comment "Nothing left to do")

(defprotocol yahalom basic
  (defrole init
    (vars (a b s name) (n-a n-b text) (k skey) (blob mesg))
    (trace (send (cat a n-a))
      (recv (cat (enc b k n-a n-b (ltk a s)) blob))
      (send (cat blob (enc n-b k)))))
  (defrole resp
    (vars (a b s name) (n-a n-b text) (k skey))
    (trace (recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))
      (recv (cat (enc a k (ltk b s)) (enc n-b k)))))
  (defrole serv
    (vars (a b s name) (n-a n-b text) (k skey))
    (trace (recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    (uniq-orig k))
  (comment "Yahalom protocol, Section 6.3.6, Page 49")
  (url "http://www.eecs.umich.edu/acal/swerve/docs/49-1.pdf"))

(defskeleton yahalom
  (vars (n-a n-b text) (a b s name) (k skey))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (traces
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s))))))
  (label 21)
  (unrealized (0 0))
  (origs (k (0 1)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton yahalom
  (vars (n-a n-b text) (a b s name) (k skey))
  (defstrand serv 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s) (k k))
  (defstrand resp 2 (n-a n-a) (n-b n-b) (a a) (b b) (s s))
  (precedes ((1 1) (0 0)))
  (non-orig (ltk a s) (ltk b s))
  (uniq-orig n-a n-b k)
  (operation encryption-test (added-strand resp 2)
    (enc a n-a n-b (ltk b s)) (0 0))
  (traces
    ((recv (cat b (enc a n-a n-b (ltk b s))))
      (send (cat (enc b k n-a n-b (ltk a s)) (enc a k (ltk b s)))))
    ((recv (cat a n-a)) (send (cat b (enc a n-a n-b (ltk b s))))))
  (label 22)
  (parent 21)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (s s) (n-a n-a) (n-b n-b) (k k))))
  (origs (k (0 1)) (n-b (1 1))))

(comment "Nothing left to do")
