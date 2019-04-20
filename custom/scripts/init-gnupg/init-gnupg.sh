#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    cleanup(){
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    pass show private.gpg > "${TEMP_DIR}/private.gpg.asc" &&
    pass show private.gpg2 > "${TEMP_DIR}/private.gpg2.asc" &&
    pass show ownertrust.gpg > "${TEMP_DIR}/ownertrust.gpg.asc" &&
    pass show ownertrust.gpg2 > "${TEMP_DIR}/ownertrust.gpg2.asc" &&
    gpg --batch import "${TEMP_DIR}/private.gpg.asc" &&
    gpg2 import "${TEMP_DIR}/private.gpg2.asc" &&
    gpg import-ownertrust "${TEMP_DIR}/ownertrust.gpg.asc" &&
    gpg2 import-ownertrust "${TEMP_DIR}/ownertrust.gpg2.asc" &&
    true
