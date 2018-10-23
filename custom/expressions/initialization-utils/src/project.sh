#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--UPSTREAM_ORGANIZATION)
	    UPSTREAM_ORGANIZATION="${2}" &&
		shift 2 &&
		true
	    ;;
	--UPSTREAM_REPOSITORY)
	    UPSTREAM_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--ORIGIN_ORGANIZATION)
	    ORIGIN_ORGANIZATION="${2}" &&
		shift 2 &&
		true
	    ;;
	--ORIGIN_REPOSITORY)
	    ORIGIN_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--REPORT_ORGANIZATION)
	    REPORT_ORGANIZATION="${2}" &&
		shift 2 &&
		true
	    ;;
	--REPORT_REPOSITORY)
	    REPORT_REPOSITORY="${2}" &&
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
    (cat <<EOF
UPSTREAM_ORGANIZATION
UPSTREAM_REPOSITORY
ORIGIN_ORGANIZATION
ORIGIN_REPOSITORY
REPORT_ORGANIZATION
REPORT_REPOSITORY
EOF
    ) | while read VAR do
    do
	eval VAL=\${${VAR}} &&
	    if [ -z "${VAL}" ]
	    then
		echo Undefined ${VAR} &&
		    echo ${0} &&
		    exit 66 &&
		    true
	    fi &&
	    true
    done &&
    if [ ! -d ${HOME}/project ]
    then
	mkdir ${HOME}/project &&
	    git -C ${HOME}/project init &&
	    git -C ${HOME}/project remote add upstream "upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_HOST}.git" &&
	    git -C ${HOME}/project remote set-url --push upstream no-push &&
	    git -C ${HOME}/project remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_HOST}.git" &&
	    git -C ${HOME}/project remote add report "report:${REPORT_ORGANIZATION}/${REPORT_HOST}.git" &&
	    ln \
		--symbolic \
		${STORE_DIR}/scripts/post-commit \
		${STORE_DIR}/scripts/pre-push \
		${HOME}/project/.git/hooks &&
	    true
    fi &&
    true

