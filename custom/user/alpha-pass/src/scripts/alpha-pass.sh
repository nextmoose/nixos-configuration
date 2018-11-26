#!/bin/sh

UUID=55ff648f-ed44-4807-8173-6544423702e2 &&
    VOLUME=$(docker volume ls --quiet --filter label=uuid=alpha-pass-home) &&
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
		--mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
		--mount type=volume,source=${VOLUME},destination=/home,readonly=true \
		init-alpha-pass &&
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
