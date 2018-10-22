#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
    trap cleanup EXIT &&
    gunzip --to-stdout ${INSTALL_DIR}/etc/secrets.tar.gz > ${TEMP_DIR}/secrets.tar &&
    mkdir ${TEMP_DIR}/secrets &&
    tar --extract --file ${TEMP_DIR}/secrets.tar --directory ${TEMP_DIR}/secrets &&
    cat ${TEMP_DIR}/secrets/${@} &&
    true
