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
    if [ ! -d ${HOME}/.password-store ]
    then
	pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
	    pass git init &&
	    pass git remote add upstream "upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
	    pass git remote set-url --push upstream no-push &&
	    pass git remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
	    pass git remote add report "report:${REPORT_ORGANIZATION}/${REPORT_REPOSITORY}.git" &&
	    ln \
		--symbolic \
		${STORE_DIR}/scripts/post-commit \
		${STORE_DIR}/scripts/pre-push \
		${HOME}/.password-store/.git/hooks \
		&&
	    true
    fi &&
    true
    
