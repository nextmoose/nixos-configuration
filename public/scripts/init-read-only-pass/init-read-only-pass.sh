#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--gpg-private-keys-file)
	    GPG_PRIVATE_KEYS_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--gpg-ownertrust-file)
	    GPG_OWNERTRUST_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--gpg2-private-keys-file)
	    GPG2_PRIVATE_KEYS_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--gpg2-ownertrust-file)
	    GPG2_OWNERTRUST_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--canonical-remote)
	    CANONICAL_REMOTE="${2}" &&
		shift 2 &&
		true
	    ;;
	--canonical-branch)
	    CANONICAL_BRANCH="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Option &&
		echo "${1}" &&
		echo "${@}" &&
		echo "${0}" &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    if [ -z "${GPG_PRIVATE_KEYS_FILE}" ]
    then
	echo Unspecified GPG_PRIVATE_KEYS_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${GPG_PRIVATE_KEYS_FILE}" ]
    then
	echo "Nonexistant GPG_PRIVATE_KEYS_FILE ${GPG_PRIVATE_KEYS_FILE}" &&
	    exit 64 &&
	    true
    elif [ -z "${GPG_OWNERTRUST_FILE}" ]
    then
	echo Unspecified GPG_OWNERTRUST_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${GPG_OWNERTRUST_FILE}" ]
    then
	echo "Nonexistant GPG_OWNERTRUST_FILE ${GPG_OWNERTRUST_FILE}" &&
	    exit 64 &&
	    true
    elif [ -z "${GPG2_PRIVATE_KEYS_FILE}" ]
    then
	echo Unspecified GPG2_PRIVATE_KEYS_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${GPG2_PRIVATE_KEYS_FILE}" ]
    then
	echo "Nonexistant GPG2_PRIVATE_KEYS_FILE ${GPG2_PRIVATE_KEYS_FILE}" &&
	    exit 64 &&
	    true
    elif [ -z "${GPG2_OWNERTRUST_FILE}" ]
    then
	echo Unspecified GPG2_OWNERTRUST_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${GPG2_OWNERTRUST_FILE}" ]
    then
	echo "Nonexistant GPG2_OWNERTRUST_FILE ${GPG2_OWNERTRUST_FILE}" &&
	    exit 64 &&
	    true
    elif [ -z "${CANONICAL_REMOTE}" ]
    then
	echo Unspecified CANONICAL_REMOTE &&
	    exit 64 &&
	    true
    elif [ -z "${CANONICAL_BRANCH}" ]
    then
	echo Unspecified CANONICAL_BRANCH &&
	    exit 64 &&
	    true
    fi &&
    export HOME=$(mktemp -d) &&
    cleanup(){
	rm --recursive --force "${HOME}" &&
	    true
    } &&
    trap cleanup EXIT &&
    cd "${HOME}" &&
    gpg --batch --import "${GPG_PRIVATE_KEYS_FILE}" &&
    gpg --import-ownertrust "${GPG_OWNERTRUST_FILE}" &&
    gpg2 --import "${GPG2_PRIVATE_KEYS_FILE}" &&
    gpg2 --import-ownertrust "${GPG2_OWNERTRUST_FILE}" &&
    pass init $(gnupg-key-id) &&
    pass git init &&
    pass git remote add canonical "${CANONICAL_REMOTE}" &&
    pass git fetch --depth 1 canonical "${CANONICAL_BRANCH}" &&
    pass git checkout "${CANONICAL_REMOTE}/${CANONICAL_BRANCH}" &&
    bash &&
    true
