#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--build-dir)
	    BUILD_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	--install-dir)
	    INSTALL_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 65 &&
		true
	    ;;
    esac &&
	true
done &&
    (cat <<EOF
BUILD_DIR
INSTALL_DIR
EOF
    ) | while read VAR
    do
	eval VAL=\${${VAR}} &&
	    if [ -z "${VAL}" ]
	    then
		echo Unspecified ${VAR} &&
		    exit 66 &&
		    true
	    fi &&
	    true
    done &&
    mkdir "${INSTALL_DIR}" &&
    if [ -d "${BUILD_DIR}/scripts" ]
    then
	cp --recursive "${BUILD_DIR}/scripts" "${INSTALL_DIR}" &&
	    true
    fi &&
    if [ -d lib ]
    then
	cp --recursive "${BUILD_DIR}/lib" "${INSTALL_DIR}" &&
	    true
    fi &&
    true

