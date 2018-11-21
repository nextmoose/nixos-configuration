#!/bin/sh

for FILE in $(ls -1 "${STORE_DIR}/lib")
do
    FILE1=${FILE%.*} &&
	FILE2=${FILE1%.*} &&
	if [ -z "$(docker image ls --filter reference=${FILE2} --quiet)" ]
	then
	    cat "${STORE_DIR}/lib/${FILE}" | docker image load &&
		true
	fi &&
	true
done &&
    true
