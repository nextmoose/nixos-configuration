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
	--detach \
	--restart always \
	zookeeper &&
    docker \
	container \
	create \
	--cidfile "${KAFKA_CID_FILE}" \
	--interactive \
	--tty \
	--rm \
	--restart always \
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
    docker container start zookeeper &&
    docker container start --interactive --tty --rm kafka &&
    true
