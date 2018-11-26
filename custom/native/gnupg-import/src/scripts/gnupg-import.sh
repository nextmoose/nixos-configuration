#!/bin/sh

TEMP_DIR="$(mktemp -d)" &&
    cleanup() {
	rm --recursive --force "${TEMP_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    echo "${GPG_SECRET_KEY}" > "${TEMP_DIR}/gpg.secret.key" &&
    echo "${GPG_OWNER_TRUST}" > "${TEMP_DIR}/gpg.owner.trust" &&
    echo "${GPG2_SECRET_KEY}" > "${TEMP_DIR}/gpg2.secret.key" &&
    echo "${GPG2_OWNER_TRUST}" > "${TEMP_DIR}/gpg2.owner.trust" &&
    gpg --batch --import "${TEMP_DIR}/gpg.secret.key" &&
    gpg --import-ownertrust "${TEMP_DIR}/gpg.owner.trust" &&
    gpg2 --import "${TEMP_DIR}/gpg2.secret.key" &&
    gpg2 --import-ownertrust "${TEMP_DIR}/gpg2.owner.trust" &&
    true
