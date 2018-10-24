#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	echo CLEANINUP UP &&
	ls -1 ${TEMP_DIR} | while read DIR
	do
	    sudo umount ${TEMP_DIR}/${DIR} &&
		sudo lvremove --force /dev/volumes/${DIR} &&
		true
	done &&
	    rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
    trap cleanup EXIT &&
    sudo lvcreate --yes --name test-0 --size 1G volumes &&
    sudo mkfs.ext4 /dev/volumes/test-0 &&
    mkdir ${TEMP_DIR}/test-0 &&
    sudo mount /dev/volumes/test-0 ${TEMP_DIR}/test-0 &&
    sudo mkdir ${TEMP_DIR}/test-0/home &&
    sudo lvcreate --yes --name test-1 --size 1G volumes &&
    sudo mkfs.ext4 /dev/volumes/test-1 &&
    mkdir ${TEMP_DIR}/test-1 &&
    sudo mount /dev/volumes/test-1 ${TEMP_DIR}/test-1 &&
    seq 0 10 | while read I
    do
	echo BEGINNING SNAPSHOT ${I} &&
	    uuidgen | sudo tee --append ${TEMP_DIR}/test-0/home/hello.txt &&
	    snapshot --snapshot-size 1G --source-volume test-0 --source-directory home --target-volume test-1 &&
	    echo FINISHING SNAPSHOT ${I} &&
	    true
    done &&
    sudo lvcreate --yes --name test-2 --size 1G volumes &&
    sudo mkfs.ext4 /dev/volumes/test-2 &&
    mkdir ${TEMP_DIR}/test-2 &&
    sudo mount /dev/volumes/test-2 ${TEMP_DIR}/test-2 &&
    cat /run/secrets/gpg.passphrase.txt | archive --name backup --source-volume test-1 --source-directory snapshots  --local-user "Archive Sender" --recipient $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") --target-volume test-2 &&
    sudo lvcreate --yes --name test-3 --size 1G volumes &&
    sudo mkfs.ext4 /dev/volumes/test-3 &&
    mkdir ${TEMP_DIR}/test-3 &&
    sudo mount /dev/volumes/test-3 ${TEMP_DIR}/test-3 &&
    export X0=$(ls -1 ${TEMP_DIR}/test-2 | head --lines 1) &&
    export X1=${X0%.*} &&
    export X2=${X1%.*} &&
    export X3=${X2%.*} &&
    export X4=${X3#*.} &&
    dearchive --name backup --source-volume test-2 --tstamp ${X4} --target-volume test-3 &&
    echo VERIFYING ARCHIVE &&
    echo diff -qrs ${TEMP_DIR}/test-3 ${TEMP_DIR}/test-1/snapshots &&
    echo VERIFYING SNAPSHOT &&
    echo diff -qrs ${TEMP_DIR}/test-3/$(ls -1 ${TEMP_DIR}/test-3/ | head --lines 1) ${TEMP_DIR}/test-0 &&
    TEMP_DIR=${TEMP_DIR} bash &&
    
    true
