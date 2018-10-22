#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--canonical-host)
	    CANONICAL_HOST="${2}" &&
		shift 2
	;;
	--canonical-organization)
	    CANONICAL_ORGANIZATION="${2}" &&
		shift 2
	;;
	--canonical-repository)
	    CANONICAL_REPOSITORY="${2}" &&
		shift 2
	;;
	--canonical-branch)
	    CANONICAL_BRANCH="${2}" &&
		shift 2
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
    trap cleanup EXIT &&
    gunzip --to-stdout ${INIT_READ_ONLY_PASS}/etc/secrets.tar.gz > ${TEMP_DIR}/secrets.tar &&
    mkdir ${TEMP_DIR}/secrets &&
    tar --extract --file ${TEMP_DIR}/secrets.tar --directory ${TEMP_DIR}/secrets &&
    mkdir ${TEMP_DIR}/home &&
    (
	export HOME=${TEMP_DIR}/home &&
	    gpg --import ${TEMP_DIR}/secrets/gpg.secret.key &&
	    gpg --import-ownertrust ${TEMP_DIR}/secrets/gpg.owner.trust &&
	    gpg2 --import ${TEMP_DIR}/secrets/gpg.secret.key &&
	    gpg2 --import-ownertrust ${TEMP_DIR}/secrets/gpg.owner.trust &&
	    pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
	    pass git init &&
	    pass git remote add canonical "https://${CANONICAL_HOST}/${CANONICAL_ORGANIZATION}/${CANONICAL_URL}.git" &&
	    pass git fetch canonical "${CANONICAL_BRANCH}" &&
	    pass git checkout "canonical/${CANONICAL_BRANCH}" &&
	    mkdir ${TEMP_DIR}/clear &&
	    pass show gpg.secret.key > ${TEMP_DIR}/clear/gpg.secret.key &&
	    pass show gpg.owner.trust > ${TEMP_DIR}/clear/gpg.owner.trust &&
	    pass show gpg2.secret.key > ${TEMP_DIR}/clear/gpg2.secret.key &&
	    pass show gpg2.owner.trust > ${TEMP_DIR}/clear/gpg2.owner.trust &&
	    pass show upstream.id_rsa > ${TEMP_DIR}/clear/upstream.id_rsa &&
	    pass show upstream.known_hosts > ${TEMP_DIR}/clear/upstream.known_hosts &&
	    pass show origin.id_rsa > ${TEMP_DIR}/clear/origin.id_rsa &&
	    pass show origin.known_hosts > ${TEMP_DIR}/clear/origin.known_hosts &&
	    pass show report.id_rsa > ${TEMP_DIR}/clear/report.id_rsa &&
	    pass show upstream.known_hosts > ${TEMP_DIR}/clear/known_hosts &&
	    true
    ) &&
    gpg --import ${TEMP_DIR}/clear/gpg.secret.key &&
    gpg --import-ownertrust ${TEMP_DIR}/clear/gpg.owner.trust &&
    gpg2 --import ${TEMP_DIR}/clear/gpg2.secret.key &&
    gpg2 --import-ownertrust ${TEMP_DIR}/clear/gpg2.owner.trust &&
    mkdir ${HOME}/.ssh &&
    chmod 0700 ${HOME}/.ssh &&
    cp ${TEMP_DIR}/clear/upstream* ${HOME}/.ssh &&
    cp ${TEMP_DIR}/clear/origin* ${HOME}/.ssh &&
    cp ${TEMP_DIR}/clear/report* ${HOME}/.ssh &&
    chmod 0400 ${HOME}/.ssh/* &&
    true
