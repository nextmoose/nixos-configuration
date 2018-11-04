#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${TEMP_DIR}" &&
	    true
    } &&
    gnucash &&
    true
