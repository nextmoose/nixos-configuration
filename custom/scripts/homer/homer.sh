#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--)
	    shift &&
		export ARGUMENTS="${@}" &&
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
    ${ARGUMENTS} &&
    true
