#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--package)
	    PACKAGE="${2}" &&
		shift 2 &&
		true
	    ;;
	--staples-file)
	    STAPLES_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--test-script-file)
	    TEST_SCRIPT_FILE="${2}" &&
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
		echo "${@}" &&
		echo "${0}" &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    if [ -z "${PACKAGE}" ]
    then
	echo Unspecified PACKAGE &&
	    exit 64 &&
	    true
    elif [ -z "${STAPLES_FILE}" ]
    then
	echo Unspecified STAPLES_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${STAPLES_FILE}" ]
    then
	echo "Nonexistant STAPLES_FILE ${STAPLES_FILE}" &&
	    exit 64 &&
	    true
    elif [ -z "${TEST_SCRIPT_FILE}" ]
    then
	echo Unspecified TEST_SCRIPT_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${TEST_SCRIPT_FILE}" ]
    then
	echo "Nonexistant TEST_SCRIPT_FILE ${TEST_SCRIPT_FILE}" &&
	    exit 64 &&
	    true
    elif [ -z "${WORK_DIR}" ]
    then
	echo Unspecified WORK_DIR &&
	    exit 64 &&
	    true
    elif [ ! -d "${WORK_DIR}" ]
    then
	echo "Nonexistant WORK_DIR ${WORK_DIR}" &&
	    exit 64 &&
	    true
    fi &&
    while true
    do
	IMPLEMENTATION=$(cat <<EOF
(import ${STAPLES_FILE} {}).${PACKAGE}
EOF
		      ) &&
	    ! nix-build --arg implementation "${IMPLEMENTATION}" --arg test-script "${TEST_SCRIPT_FILE}" "${STORE_DIR}/src/script-test.nix" &&
	    true
    done &&
    true
