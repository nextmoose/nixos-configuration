#!/bin/sh

gnupg-import &&
    pass init "$(gnupg-key-id)" &&
    pass git init &&
    pass git remote add canonical "https://${CANONICAL_HOST}/${CANONICAL_ORGANIZATION}/${CANONICAL_REPOSITORY}.git" &&
    GIT_SSL_NO_VERIFY=true pass git fetch canonical "${CANONICAL_BRANCH}" &&
    pass git checkout "canonical/${CANONICAL_BRANCH}" &&
    tail -f /dev/null &&
    sleep-forever &&
    true
