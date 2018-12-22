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
    gnupg-import &&
    dot-ssh-init &&
    mkdir "${HOME}/project" &&
    git -C "${HOME}/project" init &&
    if [ ! -z "${COMMITTER_NAME}" ] && [ ! -z "${COMMITTER_EMAIL}" ]
    then
	git -C "${HOME}/project" config user.name "${COMMITTER_NAME}" &&
	    git -C "${HOME}/project" config user.email "${COMMITTER_EMAIL}" &&
	    true
    fi &&
    if [ ! -z "${UPSTREAM_HOST}" ] && [ ! -z "${UPSTREAM_USER}" ] && [ ! -z "${UPSTREAM_PORT}" ] && [ ! -z "${UPSTREAM_ORGANIZATION}" ] && [ ! -z "${UPSTREAM_REPOSITORY}" ] && [ ! -z "${UPSTREAM_BRANCH}" ]
    then
	dot-ssh-add-domain --domain upstream --host "${UPSTREAM_HOST}" --user "${UPSTREAM_USER}" --port "${UPSTREAM_PORT}" &&
	    git -C "${HOME}/project" remote add upstream "upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
	    git -C "${HOME}/project}" remote set-url --push upstream no_push &&
	    git -C "${HOME}/project" fetch upstream "${UPSTREAM_BRANCH}" &&
	    git -C "${HOME}/project" checkout "upstream/${UPSTREAM_BRANCH}" &&
	    true
    fi &&
    if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_PORT}" ] && [ ! -z "${ORIGIN_ORGANIZATION}" ] && [ ! -z "${ORIGIN_REPOSITORY}" ] && [ ! -z "${ORIGIN_BRANCH}" ]
    then
	dot-ssh-add-domain --domain origin --host "${ORIGIN_HOST}" --user "${ORIGIN_USER}" --port "${ORIGIN_PORT}" &&
	    git -C "${HOME}/project" remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
	    git -C "${HOME}/project" fetch origin "${ORIGIN_BRANCH}" &&
	    git -C "${HOME}/project" checkout "${ORIGIN_BRANCH}" &&
	    true
    fi &&
    if [ ! -z "${REPORT_HOST}" ] && [ ! -z "${REPORT_USER}" ] && [ ! -z "${REPORT_PORT}" ] && [ ! -z "${REPORT_ORGANIZATION}" ] && [ ! -z "${REPORT_REPOSITORY}" ] && [ ! -z "${REPORT_BRANCH}" ]
    then
	dot-ssh-add-domain --domain report --host "${REPORT_HOST}" --user "${REPORT_USER}" --port "${REPORT_PORT}" &&
	    git -C "${HOME}/project" remote add report "report:${REPORT_ORGANIZATION}/${REPORT_REPOSITORY}.git" &&
	    true
    fi &&
    true
