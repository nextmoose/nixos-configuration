#!/bin/sh

ZOOKEEPER_CID_FILE="$(mktemp)" &&
    KAFKA_CID_FILE="$(mktemp)" &&
    rm \
	--force \
	"${ZOOKEEPER_CID_FILE}" \
	"${KAFKA_CID_FILE}" &&
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
	kafka \
	kafka-server-start &&
    docker \
	container \
	create \
	--cidfile "${CREATE_TOPIC_CID_FILE}" \
	kafka \
	kafka-topics --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 &&
    docker \
	network \
	connect \
	--alias zookeeper \
	"${NETWORK}" \
	"$(cat ${ZOOKEEPER_CID_FILE})" &&
    docker \
	network \
	connect \
	"${NETWORK}" \
	"$(cat ${KAFKA_CID_FILE})" &&
    docker container start "$(cat ${ZOOKEEPER_CID_FILE})" &&
    docker container start "$(cat ${KAFKA_CID_FILE})" &&
    true
