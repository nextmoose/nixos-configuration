#!/bin/sh

CONTAINER="$(docker container ls --quiet --filter label=uuid=${UUID})" &&
    if [ -z "${CONTAINER}" ]
    then
	CONTAINER=$(docker \
	    container \
	    create \
	    --interactive \
	    --tty \
	    --rm \
	    --interactive \
	    --tty \
	    --rm \
	    --env DISPLAY \
	    --env CANONICAL_HOST \
	    --env CANONICAL_ORGANIZATION \
	    --env CANONICAL_REPOSITORY \
	    --env CANONICAL_BRANCH \
	    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
	    --label=uuid=${UUID} \
	    read-only-pass) &&
	    true
    fi &&
    docker container exec --interactive --tty "${CONTAINER}" "${@}" &&
    true
