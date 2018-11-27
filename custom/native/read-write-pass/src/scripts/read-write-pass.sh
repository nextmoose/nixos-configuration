#!/bin/sh

gnupg-import &&
    dot-ssh &&
    pass init "$(gnupg-key-id)" &&
    pass git init &&
    pass git remote add origin "${ORIGIN_HOST}:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
    GIT_SSL_NO_VERIFY=true pass git fetch origin "${ORIGIN_BRANCH}" &&
    pass git checkout "${ORIGIN_BRANCH}" &&
    ln --symbolic $(which post-commit) "${HOME}/.password-store/.git/hooks" &&
    sleep-forever &&
    true
