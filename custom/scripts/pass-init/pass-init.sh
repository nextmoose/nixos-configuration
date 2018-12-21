#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
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
	--upstream-host)
	    UPSTREAM_HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-user)
	    UPSTREAM_USER="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-port)
	    UPSTREAM_PORT="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-organization)
	    UPSTREAM_ORGANIZATION="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-repository)
	    UPSTREAM_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-branch)
	    UPSTREAM_BRANCH="${2}" &&
		shift 2 &&
		true
	    ;;
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
	--origin-branch)
	    ORIGIN_BRANCH="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Option &&
		echo "${2}" &&
		echo "${@}" &&
		echo "${0}" &&
		exit 66 &&
		true
	    ;;
    esac &&
	true
done &&
    gnupg-import &&
    pass init $(gnupg-key-id) &&
    pass git init &&
    dot-ssh-init &&
    if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_PORT}" ] [ ! -z "${ORIGIN_ORGANIZATION}" ] && [ ! -z "${ORIGIN_REPOSITORY}" ] && [ ! "${ORIGIN_BRANCH}" ] && [ ! -z "${COMMITTER_NAME}" ] && [ ! -z "${COMMITTER_EMAIL}" ]
    then
	dot-ssh-add-domain --domain origin --host "${ORIGIN_HOST}" --user "${ORIGIN_USER}" --port "${ORIGIN_PORT}" &&
	    pass git config user.name "${COMMITTER_NAME}" &&
	    pass git config user.email "${COMMITTER_EMAIL}" &&
	    ln --symbolic $(which post-commit) "${HOME}/.password-store/.git/hooks" &&
	    pass git remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
	    pass git fetch origin "${ORIGIN_BRANCH}" &&
	    pass git checkout "${ORIGIN_BRANCH}" &&
	    true
    elif [ ! -z "${UPSTREAM_HOST}" ] && [ ! -z "${UPSTREAM_USER}" ] && [ ! -z "${UPSTREAM_PORT}" ] && [ ! -z "${UPSTREAM_ORGANIZATION}" ] && [ ! -z "${UPSTREAM_REPOSITORY}" ] && [ ! -z "${UPSTREAM_BRANCH}" ]
    then
	dot-ssh-add-domain --domain upstream --host "${UPSTREAM_HOST}" --user "${UPSTREAM_USER}" --port "${UPSTREAM_PORT}" &&
	    ln --symbolic $(which pre-commit) "${HOME}/.password-store/.git/hooks" &&
	    pass git remote add upstream "upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
	    pass git remote set-url --push upstream no_push &&
	    pass git fetch upstream "${UPSTREAM_BRANCH}" &&
	    pass git checkout "upstream/${UPSTREAM_BRANCH}" &&
	    true
    else
	echo "You must specify either an origin or an upstream." &&
	    exit 68 &&
	    true
    fi &&
    true
