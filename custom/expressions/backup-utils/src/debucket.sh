#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--name)
	    NAME="${2}" &&
		shift 2 &&
		true
	    ;;
	--timestamp)
	    TSTAMP="${2}" &&
		shift 2 &&
		true
	    ;;
	--destination-directory)
	    DESTINATION_DIRECTORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--bucket)
	    BUCKET="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Option &&
		echo ${1} &&
		echo ${0} &&
		echo ${@} &&
		exit 65 &&
		true
	    ;;
    esac &&
	true
done &&
    (cat <<EOF
NAME
TSTAMP
DESTINATION_DIRECTORY
EOF
    ) | while read VAR do
    do
	eval VAL=\${${VAR}} &&
	    if [ -z "${VAL}" ]
	    then
		echo Undefined ${VAR} &&
		    echo ${0} &&
		    exit 66 &&
		    true
	    fi &&
	    true
    done &&
    TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
    trap cleanup EXIT &&
    aws s3 cp s3://${BUCKET}/${NAME}.${TSTAMP}.tar.gz.gpg ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz.gpg &&
    gpg --output ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz --decrypt ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz.gpg &&
    gunzip --to-stdout ${TEMP_DIR}/${NAME}.tar.gz > ${TEMP_DIR}/${NAME}.tar &&
    mkdir ${DESTINATION_DIRECTORY} &&
    tar --extract --file ${TEMP_DIR}/${NAME}.tar --directory ${DESTINATION_DIRECTORY} &&
    true
