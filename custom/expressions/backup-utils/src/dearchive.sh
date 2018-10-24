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
	--tstamp)
	    TSTAMP="${2}" &&
		shift 2 &&
		true
	    ;;
	--target-volume)
	    TARGET_VOLUME="${2}" &&
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
TSTAMP
TARGET_VOLUME
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
    mkdir ${TEMP_DIR}/source &&
    sudo mount "/dev/volumes/${SOURCE_VOLUME}" ${TEMP_DIR}/source &&
    echo "${GPG_PASSPHRASE}" | gpg --passphrase-fd 0 --output ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz --decrypt ${TEMP_DIR}/source/${NAME}.${TSTAMP}.tar.gz.gpg &&
    gunzip --to-stdout ${TEMP_DIR}/${NAME}.${TSTAMP}.tar.gz > ${TEMP_DIR}/${NAME}.${TSTAMP}.tar &&
    mkdir ${TEMP_DIR}/target &&
    sudo mount "/dev/volumes/${TARGET_VOLUME}" ${TEMP_DIR}/target &&
    mkdir ${TEMP_DIR}/${NAME}.${TSTAMP} &&
    sudo tar --extract --file ${TEMP_DIR}/${NAME}.${TSTAMP}.tar --directory ${TEMP_DIR}/target &&
    true
