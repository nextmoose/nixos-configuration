#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
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
    if [ -z "${REMOTE}" ]
    then
	echo Unspecified REMOTE &&
	    exit 64 &&
	    true
    elif [ -z "${BRANCH}" ]
    then
	echo Unspecified BRANCH &&
	    exit 64 &&
	    true
    fi &&
    init-gnupg &&
    pass init $(gnupg-key-id) &&
    pass git init &&
    pass git remote add canonical "${REMOTE}" &&
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt &&
    pass git fetch canonical "${BRANCH}" &&
    pass git checkout "canonical/${BRANCH}" &&
    true
