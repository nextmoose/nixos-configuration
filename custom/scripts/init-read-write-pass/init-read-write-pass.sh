#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--host)
	    HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--id-rsa)
	    ID_RSA="${2}" &&
		shift 2 &&
		true
	    ;;
	--user-known-hosts)
	    USER_KNOWN_HOSTS="${2}" &&
		shift 2 &&
		true
	    ;;
	--user)
	    USER="${2}" &&
		shift 2 &&
		true
	    ;;
	--remote)
	    REMOTE="${2}" &&
		shift 2 &&
		true
	    ;;
	--branch)
	    BRANCH="${2}" &&
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
	    echo Unsupported Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    if [ -z "${HOST}" ]
    then
	echo Unspecified HOST &&
	    exit 64 &&
	    true
    elif [ -z "${ID_RSA}" ]
    then
	echo Unspecified ID_RSA &&
	    exit 64 &&
	    true
    elif [ -z "${USER_KNOWN_HOSTS}" ]
    then
	echo Unspecified USER_KNOWN_HOSTS &&
	    exit 64 &&
	    true
    elif [ -z "${USER}" ]
    then
	echo Unspecified USER &&
	    exit 64 &&
	    true
    elif [ -z "${REMOTE}" ]
    then
	echo Unspecified REMOTE &&
	    exit 64 &&
	    true
    elif [ -z "${BRANCH}" ]
    then
	echo Unspecified BRANCH &&
	    exit 64 &&
	    true
    elif [ -z "${COMMITTER_NAME}" ]
    then
	echo Unspecified COMMITTER_NAME &&
	    exit 64 &&
	    true
    elif [ -z "${COMMITTER_EMAIL}" ]
    then
	echo Unspecified COMMITTER_EMAIL &&
	    exit 64 &&
	    true
    fi &&
    init-gnupg &&
    init-dot-ssh &&
    add-ssh-domain \
	--domain origin \
	--host "${HOST}" \
	--id-rsa "${ID_RSA}" \
	--user-known-hosts "${USER_KNOWN_HOSTS}" \
	--user "${USER}" &&
    pass init $(gnupg-key-id) &&
    pass git init &&
    pass git remote add origin "${REMOTE}" &&
    pass git fetch origin "${BRANCH}" &&
    pass git rebase origin/master &&
    pass git checkout "${BRANCH}" &&
    pass git config user.name "${COMMITTER_NAME}" &&
    pass git config user.email "${COMMITTER_EMAIL}" &&
    ln --symbolic $(which post-commit) "${HOME}/.git/hooks" &&
    true
