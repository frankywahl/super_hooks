#!/usr/bin/env bash

git_repo=`git rev-parse --show-toplevel`

echo $git_repo
ln -s ${git_repo}/git_hooks/ ${git_repo}/.git/git_hooks
