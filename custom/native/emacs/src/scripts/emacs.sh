#!/bin/sh

gpg --import "${SECRETS_DIR}/lib/gpg.secret.key" &&
    gpg2 --import "${SECRETS_DIR}/lib/gpg2.secret.key" &&
    gpg --import-ownertrust "${SECRETS_DIR}/lib/gpg.owner.trust" &&
    gpg2 --import-ownertrust "${SECRETS_DIR}/lib/gpg2.owner.trust" &&
    pass init $(gpg ) &&
    pass git init &&
    pass git remote add upstream "${UPSTREAM_HOST}:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
    pass git fetch upstream "${UPSTREAM_BRANCH}" &&
    pass git checkout "upstream/${UPSTREAM_BRANCH}" &&

    true
