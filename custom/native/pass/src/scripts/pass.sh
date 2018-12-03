#!/bin/sh

gnupg-import &&
    dot-ssh &&
    pass init "$(gnupg-key-id)" &&
    pass git init &&
    pass git config user.name "${COMMITTER_NAME}" &&
    pass git config user.email "${COMMITTER_EMAIL}" &&
    pass git remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
    ls -alh ${HOME}/.ssh &&
    cat ${HOME}/.ssh/config &&
    cat ${HOME}/.ssh/origin.conf &&
    cat ${HOME}/.ssh/origin.id_rsa &&
    cat ${HOME}/.ssh/origin.known_hosts &&
    GIT_SSL_NO_VERIFY=true pass git fetch origin "${ORIGIN_BRANCH}" &&
    pass git checkout "${ORIGIN_BRANCH}" &&
    ln --symbolic $(which post-commit) "${HOME}/.password-store/.git/hooks" &&
    sleep-forever &&
    true
