#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
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
    (cat <<EOF
CANONICAL_HOST
CANONICAL_ORGANIZATION
CANONICAL_REPOSITORY
CANONICAL_BRANCH
EOF
    ) | while read VAR do
    do
	eval VAL=\${${VAR}} &&
	    if [ -z "${VAL}" ]
	    then
		echo Undefined ${VAR} &&
		    echo ${0} &&
		    exit 66 &&
		    true
	    fi &&
	    true
    done &&
    if [ ! -d ${HOME}/.gnupg ] && [ ! -d ${HOME}/.ssh ]
    then
	gunzip --to-stdout ${INSTALL_DIR}/etc/secrets.tar.gz > ${TEMP_DIR}/secrets.tar &&
	    mkdir ${TEMP_DIR}/alpha &&
	    tar --extract --file ${TEMP_DIR}/secrets.tar --directory ${TEMP_DIR}/alpha &&
	    mkdir ${TEMP_DIR}/beta &&
	    (
		export HOME=${TEMP_DIR}/beta &&
		    gpg --import ${TEMP_DIR}/alpha/gpg.secret.key &&
		    gpg --import-ownertrust ${TEMP_DIR}/alpha/gpg.owner.trust &&
		    gpg2 --import ${TEMP_DIR}/alpha/gpg2.secret.key &&
		    gpg2 --import-ownertrust ${TEMP_DIR}/alpha/gpg2.owner.trust &&
		    pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
		    pass git init &&
		    pass git remote add canonical "https://${CANONICAL_HOST}/${CANONICAL_ORGANIZATION}/${CANONICAL_REPOSITORY}.git" &&
		    pass git fetch canonical "${CANONICAL_BRANCH}" &&
		    pass git checkout "canonical/${CANONICAL_BRANCH}" &&
		    pass show gpg.secret.key > ${TEMP_DIR}/beta/gpg.secret.key &&
		    pass show gpg.owner.trust > ${TEMP_DIR}/beta/gpg.owner.trust &&
		    pass show gpg2.secret.key > ${TEMP_DIR}/beta/gpg2.secret.key &&
		    pass show gpg2.owner.trust > ${TEMP_DIR}/beta/gpg2.owner.trust &&
		    pass show upstream.id_rsa > ${TEMP_DIR}/beta/upstream.id_rsa &&
		    pass show upstream.known_hosts > ${TEMP_DIR}/beta/upstream.known_hosts &&
		    pass show origin.id_rsa > ${TEMP_DIR}/beta/origin.id_rsa &&
		    pass show origin.known_hosts > ${TEMP_DIR}/beta/origin.known_hosts &&
		    pass show report.id_rsa > ${TEMP_DIR}/beta/report.id_rsa &&
		    pass show report.known_hosts > ${TEMP_DIR}/beta/report.known_hosts &&
		    true
	    ) &&
	    gpg --import ${TEMP_DIR}/beta/gpg.secret.key &&
	    gpg --import-ownertrust ${TEMP_DIR}/beta/gpg.owner.trust &&
	    gpg2 --import ${TEMP_DIR}/beta/gpg2.secret.key &&
	    gpg2 --import-ownertrust ${TEMP_DIR}/beta/gpg2.owner.trust &&
	    mkdir ${HOME}/.ssh &&
	    mkdir ${HOME}/.ssh/config.d &&
	    chmod 0700 ${HOME}/.ssh ${HOME}/.ssh/config.d &&
	    echo "include ${HOME}/.ssh/config.d/*" > ${HOME}/.ssh/config &&
	    cat ${TEMP_DIR}/beta/upstream.id_rsa > ${HOME}/.ssh/upstream.id_rsa &&
	    cat ${TEMP_DIR}/beta/upstream.known_hosts > ${HOME}/.ssh/upstream.known_hosts &&
	    cat ${TEMP_DIR}/beta/origin.id_rsa > ${HOME}/.ssh/origin.id_rsa &&
	    cat ${TEMP_DIR}/beta/origin.known_hosts > ${HOME}/.ssh/origin.known_hosts &&
	    cat ${TEMP_DIR}/beta/report.id_rsa > ${HOME}/.ssh/report.id_rsa &&
	    cat ${TEMP_DIR}/beta/report.known_hosts > ${HOME}/.ssh/report.known_hosts &&
	    chmod 0400 ${HOME}/.ssh/config ${HOME}/.ssh/*.id_rsa ${HOME}/.ssh/*.known_hosts &&
	    true
    fi &&
    true
