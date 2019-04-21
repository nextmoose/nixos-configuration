#!/bin/sh

WORK_DIR="$(mktemp -d)" &&
    cleanup(){
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    pass show private.gpg > "${WORK_DIR}/private.gpg.asc" &&
    pass show private.gpg2 > "${WORK_DIR}/private.gpg2.asc" &&
    pass show ownertrust.gpg > "${WORK_DIR}/ownertrust.gpg.asc" &&
    pass show ownertrust.gpg2 > "${WORK_DIR}/ownertrust.gpg2.asc" &&
    gpg --batch --import "${WORK_DIR}/private.gpg.asc" &&
    gpg --import "${WORK_DIR}/private.gpg2.asc" &&
    gpg --import-ownertrust "${WORK_DIR}/ownertrust.gpg.asc" &&
    gpg2 --import-ownertrust "${WORK_DIR}/ownertrust.gpg2.asc" &&
    true
