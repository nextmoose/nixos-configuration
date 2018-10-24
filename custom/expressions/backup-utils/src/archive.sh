#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--name)
	    NAME="${2}" &&
		shift 2 &&
		true
	    ;;
	--source-volume)
	    SOURCE_VOLUME="${2}" &&
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
	--target-volume)
	    TARGET_VOLUME="${2}" &&
		shift 2 &&
		true
	    ;;
	--local-user)
	    LOCAL_USER="${2}" &&
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
SOURCE_VOLUME
RECIPIENT
TARGET_VOLUME
LOCAL_USER
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
	(sudo umount ${TEMP_DIR}/source || true) &&
	    (sudo umount ${TEMP_DIR}/target || true) &&
	    rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
    trap cleanup EXIT &&
    TSTAMP=$(date +%s) &&
    mkdir ${TEMP_DIR}/source &&
    sudo mount "/dev/volumes/${SOURCE_VOLUME}" ${TEMP_DIR}/source &&
    tar --create --file ${TEMP_DIR}/${NAME}.${TSTAMP}.tar --directory "${TEMP_DIR}/source/${SOURCE_DIRECTORY}" . &&
    gzip --to-stdout -9 ${TEMP_DIR}/${NAME}.${TSTAMP}.tar > ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz &&
    gpg --output ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz.gpg --local-user "${LOCAL_USER}" --encrypt --sign --recipient "${RECIPIENT}" ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz &&
    mkdir ${TEMP_DIR}/target &&
    sudo mount "/dev/volumes/${TARGET_VOLUME}" ${TEMP_DIR}/target &&
    while ! sudo cp ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz.gpg ${TEMP_DIR}/target
    do
	rm --recursive --force ${TEMP_DIR}/target/${NAME}.*.tar.gz.gpg &&
	    true
    done &&
    BUCKET=f3436629-7ec5-4b40-a3bb-1ff9e590e508 &&
    source /run/secrets/aws.env &&
    aws s3 cp ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz.gpg s3://${BUCKET}/${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz.gpg &&
    true
