#!/bin/sh

# ==========================================
# Overview: 
#   A few nice shortcuts for git
#
# Why?:
#   git has a built-in global config function!
#   This will keep your dotfiles succinct.
#  
# Usage: 
#   Just run once after installing git. 
#   Rerun when new aliases are added.
#
# Table of Contents:
#   1. git branches
#   2. git cob  
# ==========================================

# 1. git branches 
#
# Usage: git branches
# Output: branch commits sorted by asc chrono order

git config --global alias.branches "!echo ' ------------------------------------------------------------' && git for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:relative)%09%(refname:short)' refs/heads && echo ' ------------------------------------------------------------'"

# 2. git cob (checkout new branch)
# 
# Usage: git cob <branchname>
# Output: creates and switches to new branch

git config --global alias.cob "checkout -b"
