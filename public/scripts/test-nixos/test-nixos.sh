#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--source-dir)
	    SOURCE_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	--test-file)
	    TEST_FILE="${2}" &&
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
	    exit 64
    elif [ ! -d "${SOURCE_DIR}" ]
    then
	echo "Nonexistant SOURCE_DIR ${SOURCE_DIR}" &&
	    exit 64
    elif [ -z "${TEST_FILE}" ]
    then
	echo Unspecified TEST_FILE &&
	    exit 64
    elif [ ! -f "${TEST_FILE}" ]
    then
	echo "Nonexistant TEST_FILE ${TEST_FILE}" &&
	    exit 64
    elif [ -z "${WORK_DIR}" ]
    then
	echo Unspecified WORK_DIR &&
	    exit 64
    elif [ ! -d "${WORK_DIR}" ]
    then
	echo "Nonexistant WORK_DIR ${WORK_DIR}" &&
	    exit 64
    fi &&
    sed \
	-e "s#import \${SOURCE_DIR}/public/staples.nix#import ${SOURCE_DIR}/public/stagples.nix#" \
	-e "w${WORK_DIR}/test.nix" \
	"${STORE_DIR}" &&
    nix-build "${WORK_DIR}/test.nix" &&
    true
