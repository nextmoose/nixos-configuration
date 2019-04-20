#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--gnupghome)
	    export GNUPGHOME="${2}" &&
		shift 2 &&
		true
	    ;;
	--password-store-dir)
	    export PASSWORD_STORE_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	--)
	    shift &&
		ARGUMENTS="${@}" &&
		shift "${#}" &&
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
    pass "${ARGUMENTS}" &&
    true
