#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    docker-image-load \
	--key read-only-pass \
	--data-file "${STORE_DIR}/uuids.json" \
	--image-file "${STORE_DIR}/images/read-only-pass.tar" &&
    docker-image-load \
        --key read-write-pass \
	--data-file "${STORE_DIR}/uuids.json" \
	--image-file "${STORE_DIR}/images/read-write-pass.tar" &&
    start-read-only-pass-container \
	--key system-secrets-read-only-pass-container \
	--data-file "${STORE_DIR}/uuids.json" \
	--remote https://github.com/nextmoose/secrets.git \
	--branch master &&
    exit 65 &&
    if [ -z "$(docker-container-id $(uuid-parser --domain containers --key system-secrets-read-write-pass --data-file ${STORE_DIR}/uuids.json))" ]
    then
	CIDFILE="${WORK_DIR}/system-secrets-read-only-write.cid" &&
	    UUID=$(uuid-parser --domain containers --key system-secrets-read-write-pass --data-file "${STORE_DIR}/uuids.json") &&
	    IMAGE_ID=$(docker-image-id $(uuid-parser --domain images --key read-write-pass --data-file "${STORE_DIR}/uuids.json")) &&
	    docker \
		container \
		create \
		--cidfile "${CIDFILE}" \
		--restart always \
		--label "uuid=${UUID}" \
		"${IMAGE_ID}" \
		--host github.com \
		--user git \
		--remote origin:nextmoose/secrets.git \
		--branch master \
		--committer-name "Emory Merryman" \
		--committer-email "emory.merryman@gmail.com" &&
	    docker-container-start-and-wait-for-healthy --cidfile "${CIDFILE}" &&
	    true
    fi &&
    if [ -z "$(docker-container-id $(uuid-parser --domain containers --key browser-secrets-read-write-pass --data-file ${STORE_DIR}/uuids.json))" ]
    then
	CIDFILE="${WORK_DIR}/browser-secrets-read-write-pass.cid" &&
	    UUID=$(uuid-parser --domain containers --key browser-secrets-read-write-pass --data-file "${STORE_DIR}/uuids.json") &&
	    IMAGE_ID=$(docker-image-id $(uuid-parser --domain images --key read-write-pass --data-file "${STORE_DIR}/uuids.json")) &&
	    docker \
		container \
		create \
		--cidfile "${CIDFILE}" \
		--restart always \
		--label "uuid=${UUID}" \
		"${IMAGE_ID}" \
		--host github.com \
		--user git \
		--remote origin:nextmoose/browser-secrets.git \
		--branch master \
		--committer-name "Emory Merryman" \
		--committer-email "emory.merryman@gmail.com" &&
	    docker-container-start-and-wait-for-healthy --cidfile "${CIDFILE}" &&
	    true
    fi &&
    if [ -z "$(docker-container-id $(uuid-parser --domain containers --key challenge-secrets-read-write-pass --data-file ${STORE_DIR}/uuids.json))" ]
    then
	CIDFILE="${WORK_DIR}/challenge-secrets-read-write-pass.cid" &&
	    UUID=$(uuid-parser --domain containers --key challenge-secrets-read-write-pass --data-file "${STORE_DIR}/uuids.json") &&
	    IMAGE_ID=$(docker-image-id $(uuid-parser --domain images --key read-write-pass --data-file "${STORE_DIR}/uuids.json")) &&
	    docker \
		container \
		create \
		--cidfile "${CIDFILE}" \
		--restart always \
		--label "uuid=${UUID}" \
		"${IMAGE_ID}" \
		--host github.com \
		--user git \
		--remote origin:nextmoose/challenge-secrets.git \
		--branch master \
		--committer-name "Emory Merryman" \
		--committer-email "emory.merryman@gmail.com" &&
	    docker-container-start-and-wait-for-healthy --cidfile "${CIDFILE}" &&
	    true
    fi &&
    true
