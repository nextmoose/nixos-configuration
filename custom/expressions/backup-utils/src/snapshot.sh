#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--snapshot-size)
	    SNAPSHOT_SIZE="${2}" &&
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
		exit 65
	    ;;
    esac &&
	true
done &&
    SNAPSHOT_VOLUME_FILE=$(sudo mktemp /dev/volumes/XXXXXXXX) &&
    sudo rm --force ${SNAPSHOT_VOLUME_FILE} &&
    SNAPSHOT_MOUNT_DIR=$(mktemp -d) &&
    TARGET_MOUNT_DIR=$(mktemp -d) &&
    cleanup() {
	(sudo umount --force ${SNAPSHOT_MOUNT_DIR} || true ) &&
	    (sudo lvremove --force ${SNAPSHOT_VOLUME_FILE} || true) &&
	    (sudo umount --force ${TARGET_MOUNT_DIR} || true) &&
	    (sudo rm --recursive --force ${SNAPSHOT_MOUNT_DIR} ${TARGET_MOUNT_DIR} || true) &&
	    true
    } &&
    trap cleanup EXIT &&
    sudo \
	lvcreate \
	--size ${SNAPSHOT_SIZE} \
	--snapshot \
	--name $(basename ${SNAPSHOT_VOLUME_FILE}) \
	"/dev/volumes/${SOURCE_VOLUME}" &&
    sudo mount ${SNAPSHOT_VOLUME_FILE} ${SNAPSHOT_MOUNT_DIR} &&
    sudo mount /dev/volumes/${TARGET_VOLUME} ${TARGET_MOUNT_DIR} &&
    while ! sudo \
	    rsync \
	    --archive \
	    --delete \
	    ${SNAPSHOT_MOUNT_DIR}/${SOURCE_DIRECTORY}/. \
	    ${TARGET_MOUNT_DIR}/snapshot
    do
	sudo rm --recursive --force ${TARGET_MOUNT_DIR}/snapshots &&
	    true
    done &&
    sudo mkdir --parents ${TARGET_MOUNT_DIR}/snapshots &&
    while ! sudo cp --recursive --link ${TARGET_MOUNT_DIR}/snapshot ${TARGET_MOUNT_DIR}/snapshots/$(date +%s)
    do
	sudo rm --recursive --force ${TARGET_MOUNT_DIR}/snapshots &&
	    sudo mkdir --parents ${TARGET_MOUNT_DIR}/snapshots &&
	    true
    done &&
    true
