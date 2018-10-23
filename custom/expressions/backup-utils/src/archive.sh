#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
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
	--gpg-passphrase)
	    GPG_PASSPHRASE="${2}" &&
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
GPG_PASSPHRASE
RECEIPIENT
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
    sudo mount "${SOURCE_VOLUME}" ${TEMP_DIR}/source &&
    tar --create --file ${TEMP_DIR}/archive.${TSTAMP}.tar --directory "${TEMP_DIR}/source/${SOURCE_DIRECTORY}" . &&
    gzip --to-stdout -9 ${TEMP_DIR}/archive.${TSTAMP}.tar > ${TEMP_DIR}/archive.${TSTAMP}.tar.gz &&
    echo "${GPG_PASSPHRASE}" | gpg --passphrase-fd 0 --output ${TEMP_DIR}/archive.${TSTAMP}.tar.gz.gpg --encrypt --recipient "${RECIPIENT}" ${TEMP_DIR}/archive.${TSTAMP}.tar.gz &&
    mkisof -o ${TEMP_DIR}/archive.${TSTAMP}.tar.gz.gpg.iso -r ${TEMP_DIR}/archive.${TSTAMP}.tar.gz.gpg &&
    dvdisaster --image ${TEMP_DIR}/archive.${TSTAMP}.tar.gz.gpg.iso -mRS01 --redundancy high --create &&
    mkdir ${TEMP_DIR}/target &&
    sudo mount /dev/volumes/${TARGET_VOLUME} ${TEMP_DIR}/target &&
    sudo cp ${TEMP_DIR}/archive.${TSTAMP}.tar.gz.gpg.iso ${TEMP_DIR}/target &&
    true
