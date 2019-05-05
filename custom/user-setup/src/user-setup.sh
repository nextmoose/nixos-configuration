#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    cleanup(){
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    if [ -z "$(docker-image-id ${READ_ONLY_PASS_IMAGE_UUID})" ]
    then
	docker \
	    image \
	    load \
	    --input "${STORE_DIR}/images/read-only-pass.tar" \
	    --quiet &&
	    true
    fi &&
    mkdir "${WORK_DIR}/containers" &&
    docker \
	container \
	create \
	--cidfile "${WORK_DIR}/containers/system-secrets-read-only-pass" \
	--restart always \
	--label uuid="${SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID}" \
	$(docker-image-id "${READ_ONLY_PASS_IMAGE_UUID}") \
	--remote https://github.com/nextmoose/secrets.git \
	--branch master &&
    find "${WORK_DIR}/containers" | while read FILE
    do
	docker container start $(cat "${FILE}") &&
	    true
    done &&
    true
