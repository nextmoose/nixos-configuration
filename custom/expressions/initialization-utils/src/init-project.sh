#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
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
    mkdir project &&
    git -C project init &&
    if [ ! -z "${UPSTREAM_ORGANIZATION}" ] && [ ! -z "${UPSTREAM_REPOSITORY}" ]
    then
	git -C project remote add upstream "upstream/${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
	    git -C project remote set-url --push upstream no-push &&
	    if [ ! -z "${UPSTREAM_BRANCH}" ]
	    then
		git -C project fetch upstream "${UPSTREAM_BRANCH}" &&
		    true
	    fi &&
	    true
    fi &&
    if [ ! -z "${ORIGIN_ORGANIZATION}" ] && [ ! -z "${ORIGIN_REPOSITORY}" ]
    then
	git -C project remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
	    if [ ! -z "${ORIGIN_BRANCH}" ]
	    then
		(
		    git -C project fetch origin "${ORIGIN_BRANCH}" &&
			git -C project checkout "${ORIGIN_BRANCH}" &&
			true
		) ||
		    (
			git -C project checkout -b "${ORIGIN_BRANCH}" &&
			    true
		    )
	    fi &&
	    true
    fi &&
    if [ ! -z "${REPORT_ORGANIZATION}" ] && [ ! -z "${REPORT_REPOSITORY}" ]
    then
	git -C project remote add report "report:${REPORT_ORGANIZATION}/${REPORT_REPOSITORY}.git" &&
	    true
    fi &&
    ln --symbolic post-commit project/.git/hooks/post-commit &&
    true
    
