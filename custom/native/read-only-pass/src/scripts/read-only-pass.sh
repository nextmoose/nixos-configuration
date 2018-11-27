#!/bin/sh

echo ALPHA 00100 &&
    gnupg-import &&
    echo ALPHA 00200 &&
    pass init "$(gnupg-key-id)" &&
    echo ALPHA 00300 &&
    pass git init &&
    echo ALPHA 00400 &&
    pass git remote add canonical "https://${CANONICAL_HOST}/${CANONICAL_ORGANIZATION}/${CANONICAL_REPOSITORY}.git" &&
    echo ALPHA 00500 &&
    GIT_SSL_NO_VERIFY=true pass git fetch canonical "${CANONICAL_BRANCH}" &&
    echo ALPHA 00600 &&
    pass git checkout "canonical/${CANONICAL_BRANCH}" &&
    echo ALPHA 00700 &&
    sleep-forever &&
    echo ALPHA 00800 &&
    true
