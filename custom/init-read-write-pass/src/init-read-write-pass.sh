#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--origin-host)
	    ORIGIN_HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-user)
	    ORIGIN_USER="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-port)
	    ORIGIN_PORT="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-organization)
	    ORIGIN_ORGANIZATION="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-repository)
	    ORIGIN_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-repository)
	    ORIGIN_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-branch)
	    ORIGIN_BRANCH="${2}" &&
		shift 2 &&
		true
	    ;;
	--committer-name)
	    COMMITTER_NAME="${2}" &&
		shift 2 &&
		true
	    ;;
	--committer-email)
	    COMMITTER_EMAIL="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unknown Option &&
		echo ${1} &&
		echo ${0} &&
		echo ${@} &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    (cat <<EOF
ORIGIN_HOST
ORIGIN_USER
ORIGIN_PORT
ORIGIN_ORGANIZATION
ORIGIN_REPOSITORY
ORIGIN_BRANCH
COMMITTER_NAME
COMMITTER_EMAIL
EOF
    ) | while read VAR
    do
	eval VAL=\${${VAR}} &&
	    if [ -z "${VAR}" ]
	    then
		echo Unspecified ${VAR} &&
		    exit 66 &&
		    true
	    fi &&
	    true
    done &&
    if [ ! -d ${HOME}/.gnupg ]
    then
	init-read-only-pass \
	    --upstream-url https://github.com/nextmoose/secrets.git \
	    --upstream-branch master \
	    &&
	    mkdir ${HOME}/.ssh &&
	    chmod 0700 ${HOME}/.ssh &&
	    (cat > ${HOME}/.ssh/config <<EOF
Include ${HOME}/.ssh/origin.config
EOF
	    ) &&
	    pass show origin.id_rsa > ${HOME}/.ssh/origin.id_rsa &&
	    pass show origin.known_hosts > ${HOME}/.ssh/origin.known_hosts &&
	    if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_PORT}" ]
	    then
		(cat > ${HOME}/.ssh/origin.config <<EOF
Host origin
HostName ${ORIGIN_HOST}
User ${ORIGIN_USER}
Port ${ORIGIN_PORT}
IdentityFile ${HOME}/.ssh/origin.id_rsa
UserKnownHostsFile ${HOME}/.ssh/origin.known_hosts
EOF
		) &&
		    chmod 0600 ${HOME}/.ssh/origin.config &&
		    true
	    fi &&
	    chmod 0600 ${HOME}/.ssh/config &&
	    chmod 0600 ${HOME}/.ssh/origin.id_rsa &&
	    chmod 0600 ${HOME}/.ssh/origin.known_hosts &&
	    pass git remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
	    pass git fetch origin "${ORIGIN_BRANCH}" &&
	    pass git checkout "origin/${ORIGIN_BRANCH}" &&
	    pass git checkout -b "${ORIGIN_BRANCH}" &&
	    ln --symbolic ${STORE_DIR}/bin/post-commit ${HOME}/.password-store/.git/hooks &&
	    rm --force ${HOME}/.password-store/.git/hooks/pre-commit &&
	    rm --force ${HOME}/.password-store/.git/hooks/pre-push &&
	    ln --symbolic ${STORE_DIR}/bin/pre-push ${HOME}/.password-store/.git/hooks &&
	    true &&
    fi &&
    true
