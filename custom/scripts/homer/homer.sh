#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--entrypoint)
	    shift &&
		export ENTRYPOINT="${@}" &&
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
    export HOME=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${HOME}" &&
	    true
    } &&
    ${ENTRYPOINT} &&
    true
