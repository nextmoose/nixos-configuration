#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--home-dir)
	    HOME_DIR="${2}" &&
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
    if [ -z "${HOME_DIR}" ]
    then
	echo Unspecified HOME_DIR &&
	    exit 64 &&
	    true
    elif [ ! -d "${HOME_DIR}" ]
    then
	echo "Specified HOME_DIR=${HOME_DIR} does not exist" &&
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
    fi &&
    export GNUPGHOME="${HOME_DIR}" &&
    pass init $(gnupg-keyid) &&
    pass git init &&
    pass git remote add canonical "${REMOTE}" &&
    pass git fetch canonical "${BRANCH}" &&
    pass git checkout "canonical/${BRANCH}" &&
    true
