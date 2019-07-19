-- Channels and Channel Messages

-- Copyright (c) 2009 The MITRE Corporation
--
-- This program is free software: you can redistribute it and/or
-- modify it under the terms of the BSD License as published by the
-- University of California.

module CPSA.Channel (ChMsg (..), cmTerm, cmChan, cmMap,
                     cmMatch, cmUnify) where

import CPSA.Algebra

-- A channel is just a variable of sort message.

-- Channel Messages

-- A channel message is either a plain message or a channel and a
-- message.

data ChMsg
  = Plain !Term                 -- Plain message
  | ChMsg !Term !Term           -- Channel and a message
  deriving (Show, Eq, Ord)

-- Get channel message term
cmTerm :: ChMsg -> Term
cmTerm (Plain t) = t
cmTerm (ChMsg _ t) = t

-- Get channel message channel
cmChan :: ChMsg -> Maybe Term
cmChan (Plain _) = Nothing
cmChan (ChMsg ch _) = Just ch

-- Map term in channel message
cmMap :: (Term -> Term) -> ChMsg -> ChMsg
cmMap f (Plain  t) = Plain $ f t
cmMap f (ChMsg ch t) = ChMsg ch (f t)

-- Matching

cmMatch :: ChMsg -> ChMsg -> (Gen, Env) -> [(Gen, Env)]
cmMatch (Plain t) (Plain t') ge =
  match t t' ge
cmMatch (ChMsg ch t) (ChMsg ch' t') ge =
  do
    ge <- match ch ch' ge
    match t t' ge
cmMatch _ _ _ = []

-- Unification

cmUnify :: ChMsg -> ChMsg -> (Gen, Subst) -> [(Gen, Subst)]
cmUnify (Plain t) (Plain t') gs =
  unify t t' gs
cmUnify (ChMsg ch t) (ChMsg ch' t') gs =
  do
    gs <- unify ch ch' gs
    unify t t' gs
cmUnify _ _ _ = []
