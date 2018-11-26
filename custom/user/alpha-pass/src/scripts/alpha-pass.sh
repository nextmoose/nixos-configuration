#!/bin/sh

CONTAINER="$(docker container ls --quiet --filter label=uuid=${UUID})" &&
    if [ -z "${CONTAINER}" ]
    then
	source export-env-vars &&
	    CONTAINER=$(docker \
			    container \
			    create \
			    --env GPG_SECRET_KEY \
			    --env GPG_OWNER_TRUST \
			    --env GPG2_SECRET_KEY \
			    --env GPG2_OWNER_TRUST \
			    --env DISPLAY \
			    --env CANONICAL_HOST \
			    --env CANONICAL_ORGANIZATION \
			    --env CANONICAL_REPOSITORY \
			    --env CANONICAL_BRANCH \
			    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
			    --label=uuid=${UUID} \
			    read-only-pass) &&
	    docker container start "${CONTAINER}" &&
	    true
    fi &&
    docker container exec --interactive --tty "${CONTAINER}" "${@}" &&
    true
