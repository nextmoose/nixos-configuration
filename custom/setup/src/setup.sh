#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    if [ -z "$(docker-image-id $(uuid-parser --domain images --key read-only-pass --data-file ${STORE_DIR}/uuids.json))" ]
    then
	docker image load --quiet --input "${STORE_DIR}/images/read-only-pass.tar" &&
	    true
    fi &&
    if [ -z "$(docker-image-id $(uuid-parser --domain images --key read-write-pass --data-file ${STORE_DIR}/uuids.json))" ]
    then
	docker image load --quiet --input "${STORE_DIR}/images/read-write-pass.tar" &&
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
	    docker-container-start-and-wait-for-healthy "${CID_FILE}" &&
	    true
    fi &&
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
	    docker-container-start-and-wait-for-healthy "${CID_FILE}" &&
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
	    docker-container-start-and-wait-for-healthy "${CID_FILE}" &&
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
	    docker-container-start-and-wait-for-healthy "${CID_FILE}" &&
	    true
    fi &&
    true
