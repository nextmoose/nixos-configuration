#!/bin/sh

REMOTE="${1}" &&
    if [ "${REMOTE}" == "upstream" ]
    then
	echo Pushing to the UPSTREAM branch is not allowed. &&
	    echo Use the REPORT branch for pushing upstream. &&
	    exit 67 &&
	    true
    fi
