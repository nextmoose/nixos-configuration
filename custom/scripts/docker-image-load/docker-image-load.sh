#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--key)
	    KEY="${2}" &&
		shift 2 &&
		true
	    ;;
	--data-file)
	    DATA_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--image-file)
	    IMAGE_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unknown &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    if [ -z "${KEY}" ]
    then
	echo Unspecified KEY &&
	    exit 64 &&
	    true
    elif [ -z "${DATA_FILE}" ]
    then
	echo Unspecified DATA_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${DATA_FILE}" ]
    then
	echo Specified DATA_FILE "${DATA_FILE}" does not exist &&
	    exit 64 &&
	    true
    elif [ -z "${IMAGE_FILE}" ]
    then
	echo Unspecified IMAGE_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${IMAGE_FILE}" ]
    then
	echo Specified IMAGE_FILE "${IMAGE_FILE}" does not exist &&
	    exit 64 &&
	    true
    fi &&
    WORK_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    if [ -z "$(docker-image-id $(uuid-parser --domain images --key ${KEY} --data-file ${DATA_FILE}))" ]
    then
	docker image load --quiet --input "${IMAGE_FILE}" &&
	    true
    fi &&
    true
