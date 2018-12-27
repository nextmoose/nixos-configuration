#!/bin/sh

COMMITTER_NAME="Emory Merryman" &&
    COMMITTER_EMAIL="emory.merryman@gmail.com" &&
    UPSTREAM_HOST="github.com" &&
    UPSTREAM_USER="git" &&
    UPSTREAM_PORT="22" &&
    UPSTREAM_ORGANIZATION="rebelplutonium" &&
    UPSTREAM_BRANCH="master" &&
    ORIGIN_HOST="github.com" &&
    ORIGIN_USER="git" &&
    ORIGIN_PORT="22" &&
    ORIGIN_ORGANIZATION="nextmoose" &&
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
	    --report-host)
		REPORT_HOST="${2}" &&
		    shift 2 &&
		    true
		;;
	    --report-user)
		REPORT_USER="${2}" &&
		    shift 2 &&
		    true
		;;
	    --report-port)
		REPORT_PORT="${2}" &&
		    shift 2 &&
		    true
		;;
	    --report-organization)
		REPORT_ORGANIZATION="${2}" &&
		    shift 2 &&
		    true
		;;
	    --report-repository)
		REPORT_REPOSITORY="${2}" &&
		    shift 2 &&
		    true
		;;
	    --report-branch)
		REPORT_BRANCH="${2}" &&
		    shift 2 &&
		    true
		;;
	    *)
		echo Unsupported Option &&
		    echo "${1}" &&
		    echo "${@}" &&
		    echo "${0}" &&
		    exit 66 &&
		    true
		;;
	esac &&
	    true
    done &&
    if [ -z "${UPSTREAM_REPOSITORY}" ] && [ ! -z "${ORIGIN_REPOSITORY}" ]
    then
	UPSTREAM_REPOSITORY="${ORIGIN_REPOSITORY}" &&
	    true
    fi &&
    if [ -z "${REPORT_HOST}" ] && [ ! -z "${UPSTREAM_HOST}" ]
    then
	REPORT_HOST="${UPSTREAM_HOST}" &&
	    true
    fi &&
    if [ -z "${REPORT_USER}" ] && [ ! -z "${UPSTREAM_USER}" ]
    then
	REPORT_USER="${UPSTREAM_USER}" &&
	    true
    fi &&
    if [ -z "${REPORT_PORT}" ] && [ ! -z "${UPSTREAM_PORT}" ]
    then
	REPORT_PORT="${UPSTREAM_PORT}" &&
	    true
    fi &&
    if [ -z "${REPORT_ORGANIZATION}" ] && [ ! -z "${UPSTREAM_ORGANIZATION}" ]
    then
	REPORT_ORGANIZATION="${UPSTREAM_ORGANIZATION}" &&
	    true
    fi &&
    if [ -z "${REPORT_REPOSITORY}" ] && [ ! -z "${UPSTREAM_REPOSITORY}" ]
    then
	REPORT_REPOSITORY="${UPSTREAM_REPOSITORY}" &&
	    true
    fi &&
    if [ -z "${REPORT_BRANCH}" ] && [ ! -z "${UPSTREAM_BRANCH}" ]
    then
	REPORT_BRANCH="${UPSTREAM_BRANCH}" &&
	    true
    fi &&
    docker \
	container \
	run \
	--detach \
	--mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
	--env DISPLAY \
	--publish-all \
	lighttable \
	--committer-name "${COMMITTER_NAME}" \
	--committer-email "${COMMITTER_EMAIL}" \
	--upstream-host "${UPSTREAM_HOST}" \
	--upstream-user "${UPSTREAM_USER}" \
	--upstream-port "${UPSTREAM_PORT}" \
	--upstream-organization "${UPSTREAM_ORGANIZATION}" \
	--upstream-repository "${UPSTREAM_REPOSITORY}" \
	--upstream-branch "${UPSTREAM_BRANCH}" \
	--origin-host "${ORIGIN_HOST}" \
	--origin-user "${ORIGIN_USER}" \
	--origin-port "${ORIGIN_PORT}" \
	--origin-organization "${ORIGIN_ORGANIZATION}" \
	--origin-repository "${ORIGIN_REPOSITORY}" \
	--origin-branch "${ORIGIN_BRANCH}" \
	--report-host "${REPORT_HOST}" \
	--report-user "${REPORT_USER}" \
	--report-port "${REPORT_PORT}" \
	--report-organization "${REPORT_ORGANIZATION}" \
	--report-repository "${REPORT_REPOSITORY}" \
	--report-branch "${REPORT_BRANCH}" &&
    true
