#!/bin/sh

import-gnupg-keys &&
    pass init "$(gnupg-key-id)" &&
    pass git init &&
    pass git remote add canonical "https://${CANONICAL_HOST}:${CANONICAL_ORGANIZATION}/${CANONICAL_REPOSITORY}.git" &&
    pass git fetch canonical "${CANONICAL_BRANCH}" &&
    pass git checkout "canonical/${CANONICAL_BRANCH}" &&
    true
