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
	if [ -d "${STORE_DIR}/lib/${IMAGE}" ]
	then
	    WORK_DIR=$(mktemp -d "${TEMP_DIR}/XXXXXXXX") &&
		cd "${WORK_DIR}" &&
		cp --recursive "${STORE_DIR}/lib/${IMAGE}" "${WORK_DIR}" &&
		nix-build "${WORK_DIR}/${IMAGE}/default.nix" &&
		cat result | docker image load &&
		true
	fi &&
	    true
    done &&
    true
