#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--store)
	    echo "${STORE_DIR}" &&
		shift &&
		true
	    ;;
	--script)
	    jq --raw-output ".[\"${2}\"].script" "${STORE_DIR}/configuration.json" &&
		shift 2 &&
		true
	    ;;
	--nix)
	    echo "${STORE_DIR}/test-scripts.sh" &&
		shift &&
		true
	    ;;
	--test)
	    nix-build $(jq --raw-output ".[\"${2}\"].script" "${STORE_DIR}/configuration.json") &&
		shift 2 &&
		true
	    ;;
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
