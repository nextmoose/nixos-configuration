#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	if [ -z "$(ls -1 ${TEMP_DIR})" ]
	then
	    rm --recursive --force "${TEMP_DIR}" &&
		docker image ls &&
		true
	else
	    echo There were build errors. &&
		echo "${TEMP_DIR}" &&
		true
	fi &&
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
		date > date.log.txt 2>&1 &&
		nix-build "${WORK_DIR}/${IMAGE}/default.nix" > nix-build.log.txt 2>&1 &&
		cat result | docker image load > docker-image-load.log.txt 2>&1 &&
		chown --recursive user:users "${WORK_DIR}" &&
		chmod --recursive a+rwx "${WORK_DIR}" &&
		cd "${TEMP_DIR}" &&
		rm --recursive --force "${WORK_DIR}" &&
		true
	fi &&
	    true
    done &&
    true
