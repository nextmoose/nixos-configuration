#!/bin/sh


    gnupg-import &&
    dot-ssh &&
    pass init "$(gnupg-key-id)" &&
    pass git init &&
    echo BETA 00600 &&
    pass git config user.name "${COMMITTER_NAME}" &&
    echo BETA 00700 &&
    pass git config user.email "${COMMITTER_EMAIL}" &&
    echo BETA 00800 &&
    pass git remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
    echo BETA 00900 &&
    ls -alh ${HOME}/.ssh &&
    cat ${HOME}/.ssh/config &&
    cat ${HOME}/.ssh/origin.conf &&
    cat ${HOME}/.ssh/origin.id_rsa &&
    cat ${HOME}/.ssh/origin.known_hosts &&
    echo BETA 00910 &&
    GIT_SSL_NO_VERIFY=true pass git fetch origin "${ORIGIN_BRANCH}" &&
    echo BETA 01000 &&
    pass git checkout "${ORIGIN_BRANCH}" &&
    echo BETA 01100 &&
    ln --symbolic $(which post-commit) "${HOME}/.password-store/.git/hooks" &&
    echo BETA 01200 &&
    sleep-forever &&
    echo BETA 01300 &&
    true
