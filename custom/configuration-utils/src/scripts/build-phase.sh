#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--build-dir)
	    BUILD_DIR="${2}" &&
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
    mkdir "${BUILD_DIR}" &&
    if [ -d scripts ]
    then
	cp --recursive scripts "${BUILD_DIR}" &&
	    chmod --recursive 0500 "${BUILD_DIR}/scripts/." &&
	    true
    fi &&
    if [ -d lib ]
    then
	cp --recursive lib "${BUILD_DIR}" &&
	    chmod --recursive 0400 "${BUILD_DIR}/lib/." &&
	    true
    fi &&
    echo XXXX &&
    which makeWrapper &&
    true
