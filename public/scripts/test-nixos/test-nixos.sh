#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--source-dir)
	    SOURCE_DIR="${2}" &&
		export STAPLES_FILE="${SOURCE_DIR}/public/staples.nix" &&
		shift 2 &&
		true
	    ;;
	--test-dir)
	    export TEST_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	--timeout)
	    export TIMEOUT="${2}" &&
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
    elif [ -z "${TEST_DIR}" ]
    then
	echo Unspecified TEST_DIR &&
	    exit 64
    elif [ ! -d "${TEST_DIR}" ]
    then
	echo "Nonexistant TEST_DIR ${TEST_DIR}" &&
	    exit 64
    elif [ -z "${TIMEOUT}" ]
    then
	echo Unspecified TIMEOUT &&
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
    find "${TEST_DIR}" -mindepth 1 -maxdepth 1 -name *.pl | while read TEST_FILE
    do
	(
	    PACKAGE="$(basename ${TEST_FILE%.*})" &&
		mkdir "${WORK_DIR}/${PACKAGE}" &&
		sed \
		    -e "s#\${PACKAGE}#${PACKAGE}#" \
		    -e "w${WORK_DIR}/${PACKAGE}/package.nix" \
		    "${STORE_DIR}/src/package.nix" &&
		cat "${STORE_DIR}/src/test-nixos.nix" > "${WORK_DIR}/${PACKAGE}/test-nixos.nix" &&
		export TEST_SCRIPT="${TEST_FILE}" &&
		cd "${WORK_DIR}/${PACKAGE}" &&
		nix-build --timeout "${TIMEOUT}" "test-nixos.nix" &&
		true
	) ||
	    exit 64
    done &&
    true
