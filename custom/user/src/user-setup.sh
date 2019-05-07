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
    if [ -z "$(docker-container-id ${SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID})" ]
    then
        docker \
		container \
		create \
		--cidfile "${WORK_DIR}/containers/system-secrets-read-only-pass.cid" \
		--restart always \
		--label uuid="${SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID}" \
		$(docker-image-id "${READ_ONLY_PASS_IMAGE_UUID}") \
		--remote https://github.com/nextmoose/secrets.git \
		--branch master &&
	    true
    fi &&
    if true
    then
	echo SKIPPING &&
	    true
    elif [ -z "$(docker-container-id ${SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID})" ]
    then
	docker \
	    container \
	    create \
	    --cidfile "${WORK_DIR}/containers/system-secrets-read-write-pass.cid" \
	    --restart always \
	    --label uuid="${SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID}" \
	    $(docker-image-id "${READ_WRITE_PASS_IMAGE_UUID}") \
	    --remote origin/nextmoose/secrets.git \
	    --branch master \
	    --host github.com \
	    --user git \
	    --committer-name "Emory Merryman" \
	    --committer-email "emory.merryman@gmail.com" &&
	    true
    fi &&
    find "${WORK_DIR}/containers" -name *.cid | while read FILE
    do
	docker container start $(cat "${FILE}") &&
	    true
    done &&
    true
