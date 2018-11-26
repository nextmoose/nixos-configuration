#!/bin/sh

VOLUME=$(docker volume ls --quiet --filter label=uuid=${UUID}) &&
    if [ -z "${VOLUME}" ]
    then
	VOLUME=$(docker volume create --label=uuid=${UUID}) &&
	    docker \
		container \
		create \
		--interactive \
		--tty \
		--rm \
		--env DISPLAY \
		--env CANONICAL_HOST \
		--env CANONICAL_ORGANIZATION \
		--env CANONICAL_REPOSITORY \
		--env CANONICAL_BRANCH \
		--mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
		--mount type=volume,source=${VOLUME},destination=/home,readonly=true \
		--label=uuid=${UUID} \
		init-read-only-pass &&
	    true
    fi &&								       
    docker \
	container \
	create \
	--interactive \
	--tty \
	--rm \
	--env DISPLAY \
	--mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
	--mount type=volume,source=${VOLUME},destination=/home,readonly=true \
	alpha-pass &&
    true
