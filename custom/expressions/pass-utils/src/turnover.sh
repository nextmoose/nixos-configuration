#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
    trap cleanup EXIT &&
    mkdir ${TEMP_DIR}/output &&
    find ${HOME}/.password-store | grep "[.]gpg\$" | while read FILE
    do
	gpg --quiet --output ${TEMP_DIR}/output/$(basename ${FILE%.*}) --decrypt ${FILE} >> ${TEMP_DIR}/log.txt 2>&1 &&
	    SIZE=$(stat ${TEMP_DIR}/output/$(basename ${FILE%.*}) --printf %s) &&
	    SIZESIZE=$(echo ${SIZE} | wc --bytes) &&
	    LAST_COMMIT_DATE=$(pass git log -1 --format=%ct ${FILE}) &&
	    AGE=$(($(date +%s)-${LAST_COMMIT_DATE})) &&
	    SIZEAGE=$(echo ${AGE} | wc --bytes) &&
	    echo ${FILE%.*} ${SIZESIZE} ${SIZEAGE} ${SIZE} ${AGE} >> ${TEMP_DIR}/results.txt &&
	    rm --force ${TEMP_DIR}/output/$(basename ${FILE%.*}) &&
	    true
    done > ${TEMP_DIR}/log2.txt 2>&1 &&
	  cat ${TEMP_DIR}/results.txt | sort --key 1 | sort --numeric-sort --key 5 | sort --numeric-sort --key 4 | sort --numeric-sort --key 3 | sort --numeric-sort --key 2 &&
    true
