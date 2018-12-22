#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--committer-name)
	    COMMITTER_NAME="${2}" &&
		shift 2 &&
	    ;;
	--committer-name)
	    COMMITTER_NAME="${2}" &&
		shift 2 &&
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
    development-environment-init \
	--committer-name "${COMMITTER_NAME}" \
	--committer-email "${COMITTER_EMAIL}" \
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
    emacs project &&
    true
