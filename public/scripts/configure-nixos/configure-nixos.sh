#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--source-dir)
	    SOURCE_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	--user-password)
	    USER_PASSWORD="${2}" &&
		shift 2 &&
		true
	    ;;
	--work-dir)
	    WORK_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    if [ -z "${SOURCE_DIR}" ]
    then
	echo Unspecified SOURCE_DIR &&
	    exit 64 &&
	    true
    elif [ ! -d "${SOURCE_DIR}" ]
    then
	echo Nonexistent SOURCE_DIR &&
	    exit 64 &&
	    true
    elif [ -z "${USER_PASSWORD}" ]
    then
	echo Unspecified USER_PASSWORD &&
	    exit 64 &&
	    true
    elif [ -z "${WORK_DIR}" ]
    then
	echo Unspecified WORK_DIR &&
	    exit 64 &&
	    true
    elif [ ! -d "${WORK_DIR}" ]
    then
	echo Nonexistent WORK_DIR &&
	    exit 64 &&
	    true
    fi &&
    cp \
	--recursive \
	"${SOURCE_DIR}/configuration.nix" \
	"${SOURCE_DIR}/public" \
	"${WORK_DIR}" &&
    mkdir "${WORK_DIR}/private" &&
    echo "${USER_PASSWORD}" | mkpasswd --stdin -m sha-512 > "${WORK_DIR}/private/user-password.hashed.asc" && 
    true
