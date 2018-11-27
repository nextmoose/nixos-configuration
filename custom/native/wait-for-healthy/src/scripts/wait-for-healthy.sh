#!/bin/sh

SLEEP=1s &&
    CONTAINER=$(docker container ls --quiet --latest) &&
    while [ "${#}" -gt 0 ]
    do
	case "${1}" in
	    --sleep)
		SLEEP="${2}" &&
		    shift 2 &&
		    true
		;;
	    --container)
		CONTAINER="${2}" &&
		    shift 2 &&
		    true
		;;
	    *)
		echo Unsupported Option &&
		    echo "${1}" &&
		    echo "${0}" &&
		    echo "${@}" &&
		    exit 66 &&
		    true
		;;
	esac &&
	    true
    done &&
    while [ $(docker container inspect --format "{{ .State.Health.Status}}" "${CONTAINER}") != "running" ]
    do
	sleep "${SLEEP}" &&
	    true
    done &&
    true
