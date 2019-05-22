#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--host)
	    HOST="${2}" &&
		shift 2 &&
	    ;;
	--user)
	    USER="${2}" &&
		shift 2 &&
	    ;;
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
    PASSWORD=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -n 1) &&
    echo "${PASSWORD}" | pass insert --multiline "${HOST}/${USER}/${QUESTION}" &&
    pass generate --no-symbols 
    
