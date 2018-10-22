#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--canonical-host)
	    CANONICAL_HOST="${2}" &&
		shift 2 &&
		true
	;;
	--canonical-organization)
	    CANONICAL_ORGANIZATION="${2}" &&
		shift 2 &&
		true
	;;
	--canonical-repository)
	    CANONICAL_REPOSITORY="${2}" &&
		shift 2 &&
		true
	;;
	--canonical-branch)
	    CANONICAL_BRANCH="${2}" &&
		shift 2 &&
		true
	;;
	--key)
	    KEY="${2}" &&
		shift 2 &&
		true
	;;
	*)
	    echo Unknown Option &&
		echo ${1} &&
		echo ${0} &&
		echo ${@} &&
		exit 65 &&
		true
	;;
    esac &&
	true
done &&
    TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
    mkdir ${TEMP_DIR}/secrets &&
    install-secret gpg.secret.key > ${TEMP_DIR}/secrets/gpg.secret.key &&
    install-secret gpg.ownertrust > ${TEMP_DIR}/secrets/gpg.owner.trust &&
    install-secret gpg2.secret.key > ${TEMP_DIR}/secrets/gpg2.secret.key &&
    install-secret gpg2.ownertrust > ${TEMP_DIR}/secrets/gpg2.owner.trust &&
    mkdir ${TEMP_DIR}/home &&
    export HOME=${TEMP_DIR}/home &&
    gpg --import ${TEMP_DIR}/secrets/gpg.secret.key &&
    gpg --import-ownertrust ${TEMP_DIR}/secrets/gpg.owner.trust &&
    gpg2 --import ${TEMP_DIR}/secrets/gpg2.secret.key &&
    gpg2 --import-ownertrust ${TEMP_DIR}/secrets/gpg2.owner.trust &&
    pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
    pass git init &&
    pass git remote add canonical "https://${CANONICAL_HOST}/${CANONICAL_ORGANIZATION}/${CANONICAL_REPOSITORY}.git" &&
    pass git fetch canonical "${CANONICAL_BRANCH}" &&
    pass git checkout "canonical/${CANONICAL_BRANCH}" &&
    pass show "${KEY}" &&
    true
