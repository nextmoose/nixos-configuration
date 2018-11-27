#!/bin/sh

CONTAINER="$(docker container ls --quiet --filter label=uuid=${UUID})" &&
    if [ -z "${CONTAINER}" ]
    then
	CONTAINER=$(docker \
			container \
			create \
			--env GPG_SECRET_KEY="$(pass show gpg.secret.key)" \
			--env GPG_OWNER_TRUST="$(pass show gpg.owner.trust)" \
			--env GPG2_SECRET_KEY="$(pass show gpg2.secret.key)" \
			--env GPG2_OWNER_TRUST="$(pass show gpg2.owner.trust)" \
			--env DISPLAY \
			--env CANONICAL_HOST \
			--env CANONICAL_ORGANIZATION \
			--env CANONICAL_REPOSITORY \
			--env CANONICAL_BRANCH \
			--mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
			--label=uuid=${UUID} \
			--health-cmd health-check \
			read-only-pass) &&
	    docker container start "${CONTAINER}" &&
#	    wait-for-healthy --container "${CONTAINER}" &&
	    true
    fi &&
    docker container exec --interactive --tty "${CONTAINER}" pass "${@}" &&
    true
