#!/bin/sh

gpg --batch --import "${STORE_DIR}/lib/gpg.secret.key" &&
    gpg2 --import "${STORE_DIR}/lib/gpg2.secret.key" &&
    gpg --import-ownertrust "${STORE_DIR}/lib/gpg.owner.trust" &&
    gpg2 --import-ownertrust "${STORE_DIR}/lib/gpg2.owner.trust" &&
    true
