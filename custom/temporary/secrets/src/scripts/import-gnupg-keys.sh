#!/bin/sh

gpg --batch --import "${SECRETS_DIR}/lib/gpg.secret.key" &&
    gpg2 --import "${SECRETS_DIR}/lib/gpg2.secret.key" &&
    gpg --import-ownertrust "${SECRETS_DIR}/lib/gpg.owner.trust" &&
    gpg2 --import-ownertrust "${SECRETS_DIR}/lib/gpg2.owner.trust" &&
    true
