#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--target-dir)
	    TARGET_DIR="${2}" &&
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
TARGET_DIR
EOF
    ) | while read VAR
    do
	eval VAL=\${${VAR}} &&
	    if [ -z "${VAR}" ]
	    then
		echo Unspecified ${VAR} &&
		    exit 66 &&
		    true
	    fi &&
	    true
    done &&
    mkdir "${TARGET_DIR}" &&
    if [ -d "${BUILD_DIR}/scripts" ]
    then
	cp --recursive "${BUILD_DIR}/scripts" "${TARGET_DIR}" &&
	    true
    fi &&
    if [ -d lib ]
    then
	cp --recursive "${BUILD_DIR}/lib" "${TARGET_DIR}" &&
	    true
    fi &&
    if [ -f "${BUILD_DIR}/wrappers" ]
    then
	"${BUILD_DIR}/wrappers" --target-dir "${TARGET_DIR}" &&
	    true
    fi &&
    true
    
