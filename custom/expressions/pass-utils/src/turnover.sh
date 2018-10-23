#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
    trap cleanup EXIT &&
    find ${HOME}/.password-store | grep "[.]gpg\$" | while read FILE
    do
	gpg --output ${TEMP_DIR}/$(basename ${FILE%.*}) --decrypt ${FILE} &&
	    SIZE=$(stat ${TEMP_DIR}/$(basename ${FILE%.*}) --printf %s) &&
	    SIZESIZE=$(echo ${SIZE} | wc --bytes) &&
	    LAST_COMMIT_DATE=$(pass git log -1 --format=%ct ${FILE}) &&
	    AGE=$(($(date +%s)-${LAST_COMMIT_DATE})) &&
	    SIZEAGE=$(echo ${AGE} | wc --bytes) &&
	    echo ${FILE%.*} ${SIZESIZE} ${SIZEAGE} ${SIZE} ${AGE} &&
	    rm --force ${TEMP_DIR}/$(basename ${FILE%.*}) &&
	    true
    done | sort --key 1 | sort --numeric-sort --key 5 | sort --numeric-sort --key 4 | sort --numeric-sort --key 3 | sort --numeric-sort --key 2 &&
    true
