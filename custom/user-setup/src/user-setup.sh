#!/bin/sh

echo ${READ_ONLY_IMAGE_UUID} &&
    ROIU=$(docker-image-id ${READ_ONLY_IMAGE_UUID}) &&
    echo ${ROIU} &&
    if [ -z "$(docker-image-id ${READ_ONLY_IMAGE_UUID})" ]
    then
	docker image load --input "${STORE_DIR}/images/read-only-pass.tar" --quiet &&
	    true
    fi &&
    true
