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
	--command)
	    COMMAND="${@}" &&
		shift "${#}" &&
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
    if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_PORT}" ] [ ! -z "${ORIGIN_ORGANIZATION}" ] && [ ! -z "${ORIGIN_REPOSITORY}" ] && [ ! "${ORIGIN_BRANCH}" ] && [ ! -z "${COMMITTER_NAME}" ] && [ ! -z "${COMMITTER_EMAIL}" ]
    then
	pass-init --origin-host "${ORIGIN_HOST}" --origin-user "${ORIGIN_USER}" --origin-port "${ORIGIN_PORT}" --origin-organization "${ORIGIN_ORGANIZATION}" --origin-repository "${ORIGIN_REPOSITORY}" --origin-branch "${ORIGIN_BRANCH}" --committer-name "${COMMITTER_NAME}" --committer-email "${COMMITTER_EMAIL}" &&
	    true
    elif [ ! -z "${UPSTREAM_HOST}" ] && [ ! -z "${UPSTREAM_USER}" ] && [ ! -z "${UPSTREAM_PORT}" ] && [ ! -z "${UPSTREAM_ORGANIZATION}" ] && [ ! -z "${UPSTREAM_REPOSITORY}" ] && [ ! -z "${UPSTREAM_BRANCH}" ]
    then
	pass-init --upstream-host "${UPSTREAM_HOST}" --upstream-user "${UPSTREAM_USER}" --upstream-port "${UPSTREAM_PORT}" --upstream-organization "${UPSTREAM_ORGANIZATION}" --upstream-repository "${UPSTREAM_REPOSITORY}" --upstream-branch "${UPSTREAM_BRANCH}" &&
	    true
    else
	echo "You must specify either an origin or an upstream." &&
	    exit 68 &&
	    true
    fi &&
    pass "${COMMAND}" &&
    true
