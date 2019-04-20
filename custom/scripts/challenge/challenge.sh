#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--question)
	    QUESTION="${2}" &&
		shift 2 &&
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
    pass genera
    
