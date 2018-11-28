#!/bin/sh

git fetch upstream "${UPSTREAM_BRANCH}" &&
    git rebase "upstream/${UPSTREAM_BRANCH}" &&
    true
