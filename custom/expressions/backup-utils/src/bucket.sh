#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--name)
	    NAME="${2}" &&
		shift 2 &&
		true
	    ;;
	--source-directory)
	    SOURCE_DIRECTORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--recipient)
	    RECIPIENT="${2}" &&
		shift 2 &&
		true
	    ;;
	--local-user)
	    LOCAL_USER="${2}" &&
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
SOURCE_DIRECTORY
RECIPIENT
LOCAL_USER
BUCKET
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
    TSTAMP=$(date +%s) &&
    read-only-pass --upstream-organization nextmoose --upstream-repository secrets --upstream-branch master &&
    mkdir ${TEMP_DIR}/source &&
    tar --create --file ${TEMP_DIR}/${NAME}.${TSTAMP}.tar --directory "${SOURCE_DIRECTORY}" . &&
    gzip --to-stdout -9 ${TEMP_DIR}/${NAME}.${TSTAMP}.tar > ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz &&
    gpg --output ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz.gpg --local-user "${LOCAL_USER}" --encrypt --sign --recipient "${RECIPIENT}" ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz &&
    aws s3 cp ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz.gpg s3://${BUCKET}/${NAME}.${TSTAMP}.tar.gz.gpg &&
    true
