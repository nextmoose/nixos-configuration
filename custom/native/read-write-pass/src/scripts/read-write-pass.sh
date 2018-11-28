#!/bin/sh

echo BETA 00100 &&
    echo BETA 00110 &&
    env &&
    echo BETA 00120 &&
    gnupg-import &&
    echo BETA 00300 &&
    dot-ssh &&
    echo BETA 00400 &&
    pass init "$(gnupg-key-id)" &&
    echo BETA 00500 &&
    pass git init &&
    echo BETA 00600 &&
    pass git config user.name "${COMMITTER_NAME}" &&
    echo BETA 00700 &&
    pass git config user.email "${COMMITTER_EMAIL}" &&
    echo BETA 00800 &&
    pass git remote add origin "${ORIGIN_HOST}:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
    echo BETA 00900 &&
    ls -alh ${HOME}/.ssh &&
    GIT_SSL_NO_VERIFY=true pass git fetch origin "${ORIGIN_BRANCH}" &&
    echo BETA 01000 &&
    pass git checkout "${ORIGIN_BRANCH}" &&
    echo BETA 01100 &&
    ln --symbolic $(which post-commit) "${HOME}/.password-store/.git/hooks" &&
    echo BETA 01200 &&
    sleep-forever &&
    echo BETA 01300 &&
    true
