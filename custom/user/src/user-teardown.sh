#!/bin/sh

docker \
    container \
    stop \
    $(docker-container-id "${SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID}") \
    $(docker-container-id "${SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID}") &&
    docker \
	container \
	rm \
	$(docker-container-id "${SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID}") \
	$(docker-container-id "${SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID}") &&
    docker \
	image \
	rm \
	"${READ_ONLY_PASS_IMAGE_UUID}" &&
    true

    
