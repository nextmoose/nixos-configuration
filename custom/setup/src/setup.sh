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
    system-secrets-read-only-pass show alpha &&
    start-read-write-pass-container \
	--key system-secrets-read-write-pass \
	--data-file ${STORE_DIR}/uuids.json \
	--host github.com \
	--user git \
	--remote origin:nextmoose/secrets.git \
	--branch master \
	--committer-name "Emory Merryman" \
	--committer-email "emory.merryman@gmail.com" &&
    fun() {
	start-read-write-pass-container \
		--key browser-secrets-read-write-pass \
		--data-file "${STORE_DIR}/uuids.json" \
		--host github.com \
		--user git \
		--remote origin:nextmoose/browser-secrets.git \
		--branch master \
		--committer-name "Emory Merryman" \
		--committer-email "emory.merryman@gmail.com" &&
	    start-read-write-pass-container \
		--key challenge-secrets-read-write-pass \
		--data-file ${STORE_DIR}/uuids.json \
		--host github.com \
		--user git \
		--remote origin:nextmoose/challenge-secrets.git \
		--branch master \
		--committer-name "Emory Merryman" \
		--committer-email "emory.merryman@gmail.com" &&
	    true
    } &&
    true
