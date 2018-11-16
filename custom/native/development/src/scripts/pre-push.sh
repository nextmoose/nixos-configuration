#!/bin/sh

REMOTE="${1}" &&
    while read LOCAL_REF LOCAL_SHA REMOTE_REF _REMOTE_SHA
    do
	if [ "${REMOTE}" == "upstream" ]
	then
	    echo "Pushing to upstream is not allowed." &&
		exit 64 &&
		true
	elif [ "${REMOTE}" == "origin" ]
	then
	    exit 0 &&
		true
	elif [ "${REMOTE}" == "report" ] && [ ! -z "${REPORT_BRANCH}" ]
	then
	    echo "Pushing to report is not allowed when there is no defined REPORT_BRANCH" &&
		exit 64 &&
		true
	elif [ "${REMOTE}" == "report" ] && [ "${REMOTE_REF}" == "refs/heads/${REPORT_BRANCH}" ]
	then
	    exit 0 &&
		true
	elif [ "${REMOTE}" == "report" ]
	then
	    echo "Pushing to report is only allowed on ${REPORT_BRANCH}" &&
		exit 64 &&
		true
	else
	    echo "Pushing to remotes other than upstream, origin, and report is not allowed." &&
		exit 64 &&
		true
	fi &&
	    true
    done &&
    true
