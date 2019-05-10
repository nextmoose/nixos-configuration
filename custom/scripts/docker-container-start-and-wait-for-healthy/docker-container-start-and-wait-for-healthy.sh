#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--cidfile)
	    CIDFILE="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unknown Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    docker \
	container \
	start \
	$(cat "${CIDFILE}") &&
    while [ "$(docker inspect --format {{.State.Health.Status}} $(cat ${CIDFILE}))" != "healthy" ]
    do
	STATUS=$(docker inspect --format {{.State.Health.Status}} "$(cat ${CIDFILE})") &&
	    case "${STATUS}" in
	    healthy)
		rm --force "${CIDFILE}" &&
		    true
		;;
	    starting)
		echo Waiting for container $(cat "${CIDFILE}") to start &&
		    sleep 10s &&
		    true
		;;
	    unhealthy)
		echo Container $(cat "${CIDFILE}") is not healthy &&
		    docker container logs -f $(cat "${CIDFILE}") &&
		    exit 64 &&
		    true
		;;
	    *)
		echo Unknown Health Status for container $(cat "${CIDFILE}") &&
		    echo "${STATUS}" &&
		    sleep 60s &&
		    true
		;;
	esac &&
	    true
    done &&
    rm --force "${CIDFILE}" &&
    true
