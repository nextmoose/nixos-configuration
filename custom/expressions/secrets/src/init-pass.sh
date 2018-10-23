#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
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
	--origin-branch)
	    ORIGIN_BRANCH="${2}" &&
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
    pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
    pass git init &&
    if [ ! -z "${ORIGIN_ORGANIZATION}" ] && [ ! -z "${ORIGIN_REPOSITORY}" ]
    then
	pass git remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
	    if [ ! -z "${ORIGIN_BRANCH}" ]
	    then
		(
		    pass git fetch origin "${ORIGIN_BRANCH}" &&
			pass git checkout "${ORIGIN_BRANCH}" &&
			true
		) ||
		    (
			pass git checkout -b "${ORIGIN_BRANCH}" &&
			    true
		    )
	    fi &&
	    true
    fi &&
    ln --symbolic ${STORE_DIR}/scripts/post-commit ~/.password-store/.git/hooks &&
    true
    
