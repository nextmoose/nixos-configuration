#!/bin/sh

ZOOKEEPER_CID_FILE="$(mktemp)" &&
    KAFKA1_CID_FILE="$(mktemp)" &&
    KAFKA2_CID_FILE="$(mktemp)" &&
    KAFKA3_CID_FILE="$(mktemp)" &&
    KAFKA4_CID_FILE="$(mktemp)" &&
    rm \
	--force \
	"${ZOOKEEPER_CID_FILE}" \
	"${KAFKA1_CID_FILE}" \
	"${KAFKA2_CID_FILE}" \
	"${KAFKA3_CID_FILE}" \
	"${KAFKA4_CID_FILE}" &&
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
	--cidfile "${KAFKA1_CID_FILE}" \
	kafka \
	--broker-id 1 \
	--topic alpha \
	--topic beta \
	--topic gamma \
	--topic delta &&
    docker \
	container \
	create \
	--cidfile "${KAFKA2_CID_FILE}" \
	kafka \
	--broker-id 2 &&
    docker \
	container \
	create \
	--cidfile "${KAFKA3_CID_FILE}" \
	kafka \
	--broker-id 3 &&
    docker \
	container \
	create \
	--cidfile "${KAFKA4_CID_FILE}" \
	kafka \
	--broker-id 4 &&
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
	"$(cat ${KAFKA1_CID_FILE})" &&
    docker \
	network \
	connect \
	"${NETWORK}" \
	"$(cat ${KAFKA2_CID_FILE})" &&
    docker \
	network \
	connect \
	"${NETWORK}" \
	"$(cat ${KAFKA3_CID_FILE})" &&
    docker \
	network \
	connect \
	"${NETWORK}" \
	"$(cat ${KAFKA4_CID_FILE})" &&
    docker container start "$(cat ${ZOOKEEPER_CID_FILE})" &&
    docker container start "$(cat ${KAFKA1_CID_FILE})" &&
    docker container start "$(cat ${KAFKA2_CID_FILE})" &&
    docker container start "$(cat ${KAFKA3_CID_FILE})" &&
    docker container start "$(cat ${KAFKA4_CID_FILE})" &&
    true
