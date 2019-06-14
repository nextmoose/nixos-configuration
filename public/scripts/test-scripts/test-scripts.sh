#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--implementation)
	    jq --raw-output ".[\"${2}\"].implementation" "${STORE_DIR}/configuration.json" &&
		shift 2 &&
		true
	;;
	--results)
	    chromium $(jq --raw-output ".[\"${2}\"].results" "${STORE_DIR}/configuration.json")/log.html &&
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
    true
