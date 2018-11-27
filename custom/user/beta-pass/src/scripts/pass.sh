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
			    --env ORIGIN_ID_RSA="$(pass show origin.id_rsa)" \
			    --env ORIGIN_KNOWN_HOSTS="$(pass show origin.known_hosts)" \
			    --env DISPLAY \
			    --env COMMITER_NAME \
			    --env COMMITTER_EMAIL \
			    --env ORIGIN_HOST \
			    --env ORIGIN_ORGANIZATION \
			    --env ORIGIN_REPOSITORY \
			    --env ORIGIN_BRANCH \
			    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
			    --label=uuid=${UUID} \
			    read-write-pass) &&
	    docker container start "${CONTAINER}" &&
	    wait-for-healthy --container "${CONTAINER}" &&
	    true
    fi &&
    docker container exec --interactive --tty "${CONTAINER}" pass "${@}" &&
    true
