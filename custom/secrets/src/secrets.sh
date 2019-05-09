#!/bin/sh

while [ "$(docker inspect --format {{.State.Health.Status}} $(docker container ls --quiet --filter label=uuid=${UUID} --no-trunc))" != "healthy" ]
    do
	STATUS=$(docker inspect --format {{.State.Health.Status}} $(docker container ls --quiet --filter label=uuid=${UUID} --no-trunc)) &&
	    case "${STATUS}" in
	    healthy)
		rm --force "${CIDFILE}" &&
		    true
		;;
	    starting)
		sleep 0.1s &&
		    true
		;;
	    unhealthy)
		echo Container is not healthy &&
		    docker container logs -f $(cat "${CIDFILE}") &&
		    exit 64 &&
		    true
		;;
	    *)
		echo Unknown Health Status for container $(cat "${CIDFILE}") &&
		    echo "${STATUS}" &&
		    sleep 1s &&
		    true
		;;
	esac &&
	    true
    done &&
    docker \
    container \
    exec \
    --interactive \
    --tty \
    $(docker container ls --quiet --filter "label=uuid=${UUID}" --no-trunc) \
    pass \
    ${@} &&
    true
