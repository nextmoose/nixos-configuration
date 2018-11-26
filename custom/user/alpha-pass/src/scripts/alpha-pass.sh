#!/bin/sh

INIT_CID_FILE=$(mktemp) &&
    PASS_CID_FILE=$(mktemp) &&
    PASS_VID_FILE=$(mktemp) &&
    rm --force "${INIT_CID_FILE}" "${PASS_CID_FILE}" &&
    VOLUME=$(docker volume ls --quiet --filter label=uuid=${UUID}) &&
    if [ -z "${VOLUME}" ]
    then
	docker volume create --label=uuid=${UUID} > ${PASS_VID_FILE} &&
	    VOLUME="$(cat ${PASS_VID_FILE})" &&
	    rm --force "${PASS_VID_FILE}" &&
	    docker \
		container \
		create \
		--cidfile "${INIT_CID_FILE}" \
		--interactive \
		--tty \
		--rm \
		--env DISPLAY \
		--env CANONICAL_HOST \
		--env CANONICAL_ORGANIZATION \
		--env CANONICAL_REPOSITORY \
		--env CANONICAL_BRANCH \
		--mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
		--mount type=volume,source=${VOLUME},destination=/home,readonly=false \
		--label=uuid=${UUID} \
		init-read-only-pass &&
	    docker container start --interactive $(cat ${INIT_CID_FILE}) &&
	    rm --force "${INIT_CID_FILE}" &&
	    true
    fi &&								       
    docker \
	container \
	create \
	--cidfile "${PASS_CID_FILE}" \
	--interactive \
	--tty \
	--rm \
	--env DISPLAY \
	--mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
	--mount type=volume,source=${VOLUME},destination=/home,readonly=true \
	pass &&
    docker container start --interactive "$(cat ${PASS_CID_FILE})" &&
    rm --force "${PASS_CID_FILE}" &&
    true
