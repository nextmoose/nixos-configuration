#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--password-store-dir)
	    export PASSWORD_STORE_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	--gnupghome)
	    export GNUPGHOME="${2}" &&
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
    if [ -z "${PASSWORD_STORE_DIR}" ]
    then
	echo Unspecified PASSWORD_STORE_DIR &&
	    exit 64 &&
	    true
    elif [ ! -d "${PASSWORD_STORE_DIR}" ]
    then
	echo "Specified PASSWORD_STORE_DIR=${PASSWORD_STORE_DIR} does not exist" &&
	    exit 64 &&
	    true
    elif [ -z "${GNUPGHOME}" ]
    then
	echo Unspecified GNUPGHOME &&
	    exit 64 &&
	    true
    elif [ ! -d "${GNUPGHOME}" ]
    then
	echo "Specified GNUPGHOME=${GNUPGHOME} does not exist" &&
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
    pass init $(gnupg-key-id) &&
    pass git init &&
    pass git remote add origin "${REMOTE}" &&
    pass git fetch origin "${BRANCH}" &&
    pass git checkout --track -b master origin/master &&
    pass git checkout "${BRANCH}" &&
    pass git config user.name "${COMMITTER_NAME}" &&
    pass git config user.email "${COMMITTER_EMAIL}" &&
    ln --symbolic $(which post-commit) "${PASSWORD_STORE_DIR}/.git/hooks" &&
    true
