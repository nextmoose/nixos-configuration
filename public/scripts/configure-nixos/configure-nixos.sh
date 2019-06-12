#!/bin/sh

echo AAAA 0001000 &&
while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--salt)
	    SALT="${2}" &&
		shift 2 &&
		true
	    ;;
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
echo AAAA 0002000 &&
    if [ -z "${SALT}" ]
    then
	echo Unspecified SALT &&
	    exit 64 &&
	    true
    elif [ -z "${SOURCE_DIR}" ]
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
echo AAAA 0003000 &&
    cp \
	--recursive \
	"${SOURCE_DIR}/configuration.nix" \
	"${SOURCE_DIR}/public" \
	"${WORK_DIR}" &&
    mkdir "${WORK_DIR}/private" &&
echo AAAA 0004000 &&
    echo "${USER_PASSWORD}" | mkpasswd --stdin -m sha-512 --salt "${SALT}" > "${WORK_DIR}/private/user-password.hashed.asc" &&
echo AAAA 0005000 &&
    echo YES &&
echo AAAA 0006000 &&
    true
