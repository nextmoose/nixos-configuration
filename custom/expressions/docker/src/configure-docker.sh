#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${TEMP_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    docker system prune --force --all --volumes &&
    ls -1 "${STORE_DIR}/lib" | while read IMAGE
    do
	mkdir "${TEMP_DIR}/${IMAGE%.*}" &&
	    cd "${TEMP_DIR}/${IMAGE%.*}" &&
	    nix-build "${STORE_DIR}/lib/${IMAGE}" &&
	    cat result | docker image load &&
	    cd "${TEMP_DIR}" &&
	    rm --recursive --force "${TEMP_DIR}/${IMAGE%.*}" &&
	    true
    done &&
    true
