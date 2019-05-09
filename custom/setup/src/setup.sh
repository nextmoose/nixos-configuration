#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    if [ -z "$(docker-image-id $(uuid-parser --domain images --key read-only-pass ${STORE_DIR}/uuids.json))" ]
    then
	docker image load --quiet --input "${STORE_DIR}/images/read-only-pass.tar" &&
	    true
    fi &&
    if [ -z "$(docker-container-id $(uuid-parser --domain containers --key system-secrets-read-only-pass --data-file ${STORE_DIR}/uuids.json))" ]
    then
	CIDFILE="${WORK_DIR}/system-secrets-read-only-pass.cid" &&
	    UUID=$(uuid-parser --domain containers --key system-secrets-read-only-pass --data-file "${STORE_DIR}/uuids.json") &&
	    IMAGE_ID=$(docker-image-id $(uuid-parser --domain images --key read-only-pass --data-file "${STORE_DIR}/uuids.json")) &&
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
    find "${WORK_DIR}" -name *.cid | while read CIDFILE
    do
	docker container start $(cat ${CIDFILE}) &&
	    rm --force "${CIDFILE}" &&
	    true
    done &&
    true
