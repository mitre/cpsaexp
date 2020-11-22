(** * Semantics of Procedures

    This section provides the semantics of procedures generated by the
    role compiler. *)

Require Import ListSet Bool Program Monad Proc Alg.
Import List.ListNotations.
Open Scope list_scope.
Open Scope nat_scope.
(** printing <- #←# *)
(** printing ∘ %\ensuremath{\circ}% *)

(** A runtime environment *)

Definition env: Set := list (pvar * alg).

(** Executions are roles *)

Record role: Set :=
  mkRole {
      trace: list evt;
      uniqs: list alg;
      inputs: list alg;
      outputs: list alg }.

(** Is [x] not in list [l]? *)

Definition not_in (x: alg) (l: list alg): bool :=
  negb (set_mem alg_dec x l).

(** Does list [l] contain duplicates? *)

Fixpoint has_no_dups (l: list alg): bool :=
  match l with
  | [] => true
  | x :: xs => not_in x xs && has_no_dups xs
  end.

(** Is [p] a valid role? *)

Definition valid_role (p: role): bool :=
  match fold_m well_formed_event [] (trace p) with
  | None => false
  | Some decls =>
    forallb (well_sorted decls) (uniqs p) &&
    forallb (flip orig (trace p)) (uniqs p) &&
    forallb is_basic (uniqs p) &&
    has_no_dups (uniqs p) &&
    forallb (well_sorted_with_chan decls) (inputs p) &&
    forallb (fun x => is_chan x || is_basic x) (inputs p) &&
    forallb (well_sorted decls) (outputs p) &&
    forallb (flip not_in (uniqs p)) (inputs p) &&
    forallb (flip not_in (outputs p)) (inputs p)
  end.

(** Check the sort of an element of the message algebra. *)

Inductive sort_check: sort -> alg -> Prop :=
| Text_check: forall v,
    sort_check Text (Tx v)
| Data_check: forall v,
    sort_check Data (Dt v)
| Name_check: forall v,
    sort_check Name (Nm v)
| Skey_check: forall k,
    sort_check Skey (Sk k)
| Akey_check: forall k,
    sort_check Akey (Ak k)
| Ikey_check: forall k,
    sort_check Ikey (Ik k)
| Chan_check: forall v,
    sort_check Chan (Ch v)
| Mesg_check: forall a,
    sort_check Mesg a.
Hint Constructors sort_check : core.

(** The semantics of an expression

   This predicate captures the semantics of a let binding

<<
   Parmeters:
   env:      Input environment
   list evt: Input trace
   list alg: Input list of uniques
   expr:     Expression code fragment
   alg:      Value of the expression
   list evt: Output trace
   list alg: Output list of uniques
>>
*)

Inductive expr_sem: env -> list evt -> list alg -> expr ->
                    alg -> list evt -> list alg -> Prop :=
| Expr_tagg: forall ev tr us x,
    expr_sem ev tr us (Tagg x) (Tg x) tr us
| Expr_hash: forall ev tr us x a,
    lookup x ev = Some a ->
    expr_sem ev tr us (Hash x) (Hs a) tr us
| Expr_pair: forall ev tr us x y a b,
    lookup x ev = Some a ->
    lookup y ev = Some b ->
    expr_sem ev tr us (Pair x y) (Pr a b) tr us
| Expr_encr: forall ev tr us x y a b,
    lookup x ev = Some a ->
    lookup y ev = Some b ->
    expr_sem ev tr us (Encr x y) (En a b) tr us
| Expr_frst: forall ev tr us x a b,
    lookup x ev = Some (Pr a b) ->
    expr_sem ev tr us (Frst x) a tr us
| Expr_scnd: forall ev tr us x a b,
    lookup x ev = Some (Pr a b) ->
    expr_sem ev tr us (Scnd x) b tr us
| Expr_decr: forall ev tr us x y a b,
    lookup x ev = Some (En a b) ->
    lookup y ev = Some (inv b) ->
    expr_sem ev tr us (Decr x y) a tr us
| Expr_nonce: forall ev tr us a,
    expr_sem ev tr (a :: us) Nonce a tr us
| Expr_recv: forall ev tr us a c d,
    lookup c ev = Some (Ch d) ->
    expr_sem ev (Rv d a :: tr) us (Recv c) a tr us.
Hint Constructors expr_sem : core.

(** The semantics of a statement

<<
   Parmeters:
   env:      Input environment
   list evt: Input trace
   list alg: Input list of uniques
   stmts:    Statements
   env:      Output environment
   list evt: Output trace
   list alg: Output list of uniques
>>
*)

Inductive stmt_sem: env -> list evt -> list alg ->
                    stmt -> env -> list evt ->
                    list alg -> Prop :=
| Stmt_bind: forall ev tr us exp val dcl tr' us',
    expr_sem ev tr us exp val tr' us' ->
    sort_check (snd dcl) val ->
    stmt_sem ev tr us (Bind dcl exp) ((fst dcl, val) :: ev) tr' us'
| Stmt_send: forall ev tr us c d x a,
    lookup c ev = Some (Ch d) ->
    lookup x ev = Some a ->
    stmt_sem ev (Sd d a :: tr) us (Send c x) ev tr us
| Stmt_same: forall ev tr us x y a b,
    lookup x ev = Some a ->
    lookup y ev = Some b ->
    a = b ->                    (* Sameness check *)
    has_enc a = false ->        (* For probabilistic encryption *)
    stmt_sem ev tr us (Same x y) ev tr us.
Hint Constructors stmt_sem : core.

(** Statement list semantics *)

Inductive stmt_list_sem:
  env -> list evt -> list alg ->
  list alg -> list stmt -> env ->
  list evt -> list alg -> Prop :=
| Stmt_return: forall ev outs vs,
    map_m (flip lookup ev) vs = Some outs ->
    stmt_list_sem ev [] [] outs [Return vs] ev [] []
| Stmt_pair: forall ev tr us outs stmt ev' tr' us' stmts ev'' tr'' us'',
    stmt_sem ev tr us stmt ev' tr' us' ->
    stmt_list_sem ev' tr' us' outs stmts ev'' tr'' us'' ->
    stmt_list_sem ev tr us outs (stmt :: stmts) ev'' tr'' us''.
Hint Constructors stmt_list_sem : core.

Fixpoint mk_env (ds: list decl) (xs: list alg): env :=
  match (ds, xs) with
  | ((v, _) :: ds, x :: xs) =>
    (v, x) :: mk_env ds xs
  | _ => []
  end.

Inductive ins_inputs: list decl -> list alg -> Prop :=
| Ins_inputs_nil: ins_inputs nil nil
| Ins_inputs_pair: forall v s ds x xs,
    sort_check s x ->
    ins_inputs ds xs ->
    ins_inputs ((v, s) :: ds) (x :: xs).
Hint Constructors ins_inputs : core.

(** The semantics of a procedure using statement lists *)

Definition sem (p: proc) (ev: env) (e: role): Prop :=
  let ev_in := mk_env (ins p) (inputs e) in
  ins_inputs (ins p) (inputs e) /\
  stmt_list_sem ev_in (trace e) (uniqs e) (outputs e) (body p) ev [] [].

(** ** Matching *)

Definition extend_term (ev: env) (v: pvar) (x: alg): option env :=
  match lookup v ev with
  | None => Some ((v, x) :: ev)
  | Some y =>
    if alg_dec x y then
      Some ev
    else                        (* Term clash! *)
      None
  end.

Definition match_skey (ev: env) (x y: skey): option env :=
  match (x, y) with
  | (Sv v, w) => extend_term ev v (Sk w)
  | (Lt v w, Lt x y) =>
    ev <- extend_term ev v (Nm x);
    extend_term ev w (Nm y)
  | _ => None
  end.

Definition match_akey (ev: env) (x y: akey): option env :=
  match (x, y) with
  | (Av v, w) => extend_term ev v (Ak w)
  | (Pb v, Pb w) => extend_term ev v (Nm w)
  | (Pb2 s v, Pb2 t w) =>
    if string_dec s t then
      extend_term ev v (Nm w)
    else
      None
  | _ => None
  end.

Fixpoint match_term (ev: env) (x y: alg): option env :=
  match (x, y) with
  | (Tx v, Tx w) => extend_term ev v (Tx w)
  | (Dt v, Dt w) => extend_term ev v (Dt w)
  | (Nm v, Nm w) => extend_term ev v (Nm w)
  | (Sk v, Sk w) => match_skey ev v w
  | (Ak v, Ak w) => match_akey ev v w
  | (Ak (Av v), Ik w) => extend_term ev v (Ik w)
  | (Ik v, Ik w) => match_akey ev v w
  | (Ik (Av v), Ak w) => extend_term ev v (Ik w)
  | (Ch v, Ch w) => extend_term ev v (Ch w)
  | (Mg v, w) => extend_term ev v w
  | (Tg s, Tg t) =>
    if string_dec s t then
      Some ev
    else
      None
  | (Pr v w, Pr x y) =>
    ev <- match_term ev v x;
    match_term ev w y
  | (En v w, En x y) =>
    ev <- match_term ev v x;
    match_term ev w y
  | (Hs v, Hs w) => match_term ev v w
  | _ => None
  end.

Definition match_evt (ev: env) (x y: evt): option env :=
  match (x, y) with
  | (Sd c x, Sd d y) =>
    ev <- match_term ev (Ch c) (Ch d);
    match_term ev x y
  | (Rv c x, Rv d y) =>
    ev <- match_term ev (Ch c) (Ch d);
    match_term ev x y
  | _ => None
  end.

Fixpoint match_trace (ev: env) (xs ys: list evt): option env :=
  match (xs, ys) with
  | ([], []) => Some ev
  | (x :: xs, y :: ys) =>
    ev <- match_evt ev x y;
    match_trace ev xs ys
  | _ => None
  end.

Fixpoint match_list (ev: env) (xs ys: list alg): option env :=
  match (xs, ys) with
  | ([], []) => Some ev
  | (x :: xs, y :: ys) =>
    ev <- match_term ev x y;
    match_list ev xs ys
  | _ => None
end.

(** ** Role Homomorphism

    See if [x] matches one item in [ys]. *)

Fixpoint match_one (ys: list alg) (ev: env) (x: alg): option env :=
  match ys with
  | [] => None
  | y :: ys =>
    match match_term ev x y with
    | Some ev => Some ev
    | None => match_one ys ev x
    end
  end.

Definition match_uniqs (ev: env) (xs ys: list alg): option env :=
  fold_m (match_one ys) ev xs.

(** There exists a homomorphism from [x] to [y] iff the result is not
    [None]. *)

Definition homomorphism (x y: role): option env :=
  ev <- match_trace [] (trace x) (trace y);
  ev <- match_uniqs ev (uniqs x) (uniqs y);
  ev <- match_list ev (inputs x) (inputs y);
  match_list ev (outputs x) (outputs y).

(** ** Correct Input and Output *)

Definition correct_io_liveness (rl: role) (p: proc): Prop :=
  valid_role rl = true /\
  exists ev ex,
    inputs rl = inputs ex /\
    sem p ev ex /\
    homomorphism rl ex <> None /\
    homomorphism ex rl <> None.

Definition correct_io_safety (rl: role) (p: proc): Prop :=
  forall ev ex,
    inputs rl = inputs ex ->
    sem p ev ex ->
    homomorphism rl ex <> None.

(** Try using the role as the execution, but remember that the uniques
    are a set and list order might differ. *)

Lemma correct_io_liveness_aid:
  forall (rl: role) (p: proc),
    valid_role rl = true ->
    (exists ev ex uniqs,
        ex = mkRole (trace rl) uniqs (inputs rl) (outputs rl) /\
        sem p ev ex /\
        homomorphism rl ex <> None /\
        homomorphism ex rl <> None) ->
    correct_io_liveness rl p.
Proof.
  intros rl p G H.
  destruct H as [ev H].
  destruct H as [ex H].
  destruct H as [uniqs H].
  unfold correct_io_liveness.
  split; auto.
  destruct H.
  exists ev; exists ex.
  subst; auto.
Qed.
