#!/bin/sh

export GPG_SECRET_KEY="$(cat ${STORE_DIR}/lib/gpg.secret.key)" &&
    export GPG_OWNER_TRUST="$(cat ${STORE_DIR}/lib/gpg.owner.trust)" &&
    export GPG2_SECRET_KEY="$(cat ${STORE_DIR}/lib/gpg2.secret.key)" &&
    export GPG2_OWNER_TRUST="$(cat ${STORE_DIR}/lib/gpg2xs.owner.trust)" &&
    true
