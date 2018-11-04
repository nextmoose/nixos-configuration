#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${TEMP_DIR}" &&
	    true
    } &&
    cp ${STORE_DIR}/lib/.gconf.path ${HOME}/.gconf.path &&
    gconftool-2 --shutdown &&
    gnucash &&
    true
