#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--results)
	    chromium $(jq --raw-output ".[\"${@}\"]" "${STORE_DIR}/configuration.json")/log.html &&
		shift &&
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
    true
