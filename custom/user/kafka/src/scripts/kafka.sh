#!/bin/sh

ZOOKEEPER_CID_FILE="$(mktemp)" &&
    KAFKA_CID_FILE="$(mktemp)" &&
    rm --force "${ZOOKEEPER_CID_FILE}" "${KAFKA_CID_FILE}" &&
    NETWORK=$(docker \
		  network \
		  create \
		  $(uuidgen)) &&
    docker \
	container \
	create \
	--cidfile "${ZOOKEEPER_CID_FILE}" \
	--restart always \
	zookeeper &&
    docker \
	container \
	create \
	--cidfile "${KAFKA_CID_FILE}" \
	--interactive \
	--rm \
	kafka &&
    docker \
	network \
	connect \
	--alias zookeeper \
	"${NETWORK}" \
	"$(cat ${ZOOKEEPER_CID_FILE})" &&
    docker \
	network \
	connect \
	--alias kafka \
	"${NETWORK}" \
	"$(cat ${KAFKA_CID_FILE})" &&
    docker container start "$(cat ${ZOOKEEPER_CID_FILE})" &&
    docker container start --interactive "$(cat ${KAFKA_CID_FILE})" &&
    true
