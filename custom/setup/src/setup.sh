#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    if [ -z "$(docker-image-id $(jq -r --from-file ${STORE_DIR}/src/queries/images/read-only-pass.js ${STORE_DIR}/uuids.json))" ]
    then
	docker image load --quiet --input "${STORE_DIR}/images/read-only-pass.tar" &&
	    true
    fi &&
    echo AAA &&
    if [ -z "$(docker-container-id $(jq -r --from-file ${STORE_DIR}/src/queries/containers/system-secrets-read-only-pass.js ${STORE_DIR}/uuids.json))" ]
    then
	echo BBB &&
	    CIDFILE="${WORK_DIR}/system-secrets-read-only-pass.cid" &&
	    UUID=$(jq -r --from-file "${STORE_DIR}/src/queries/containers/system-secrets-read-only-pass.js") &&
	    IMAGE_ID=$(docker-image-id $(jq -r --from-file "${STORE_DIR}/src/queries/images/read-only-pass.js" "${STORE_DIR}/uuids.json")) &&
	    echo \
		docker \
		container \
		create \
		--cidfile "${CIDFILE}" \
		--restart always \
		--label "uuid=${UUID}" \
		"${IMAGE_ID}" \
		--remote https://github.com/nextmoose/secrets.git \
		--branch master &&
	    docker \
		container \
		create \
		--cidfile "${CIDFILE}" \
		--restart always \
		--label "uuid=${UUID}" \
		"${IMAGE_ID}" \
		--remote https://github.com/nextmoose/secrets.git \
		--branch master &&
	    echo DDD 2 &&
	    true
    fi &&
    echo EEE &&
    find "${WORK_DIR}" -name *.cid | while read CIDFILE
    do
	echo FFF ${CIDFILE} &&
	    docker container start $(cat ${CIDFILE}) &&
	    rm --force "${CIDFILE}" &&
	    echo GGG ${CIDFILE} &&
	    true
    done &&
    true
