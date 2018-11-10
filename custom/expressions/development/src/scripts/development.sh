#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--committer-name)
	    COMMITTER_NAME="${2}" &&
		shift 2
	    ;;
	--committer-email)
	    COMMITTER_EMAIL="${2}" &&
		shift 2
	    ;;
	--upstream-host)
	    UPSTREAM_HOST="${2}" &&
		shift 2
	    ;;
	--upstream-user)
	    UPSTREAM_USER="${2}" &&
		shift 2
	    ;;
	--upstream-port)
	    UPSTREAM_PORT="${2}" &&
		shift 2
	    ;;
	--upstream-organization)
	    UPSTREAM_ORGANIZATION="${2}" &&
		shift 2
	    ;;
	--upstream-repository)
	    UPSTREAM_REPOSITORY="${2}" &&
		shift 2
	    ;;
	--upstream-branch)
	    UPSTREAM_BRANCH="${2}" &&
		shift 2
	    ;;
	*)
	    echo Unknown Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 65 &&
		true
	    ;;
    esac &&
done &&
    cat ${IMAGE} | docker image load &&
    docker \
	container \
	run \
	--interactive \
	--tty \
	--rm \
	--env COMMITTER_NAME="${COMMITTER_NAME}" \
	--env COMMITER_EMAIL="${COMMITTER_EMAIL}" \
	--env UPSTREAM_HOST="${UPSTREAM_HOST}" \
	--env UPSTREAM_USER="${UPSTREAM_USER}" \
	--env UPSTREAM_PORT="${UPSTREAM_PORT}" \
	--env UPSTREAM_ORGANIZATION="${UPSTREAM_ORGANIZATION}" \
	--env UPSTREAM_REPOSITORY="${UPSTREAM_REPOSITORY}" \
	--env UPSTREAM_BRANCH="${UPSTREAM_BRANCH}" \
	development &&
    true
