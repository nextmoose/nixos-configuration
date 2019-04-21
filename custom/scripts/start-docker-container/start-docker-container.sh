#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--image)
	    IMAGE="${2}" &&
		shift 2 &&
		true
	    ;;
	--name)
	    NAME="${2}" &&
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
    if [ -z "${IMAGE}" ]
    then
	echo Unspecified IMAGE &&
	    exit 64 &&
	    true
    elif [ -z "$(docker image ls --quiet --filter reference=${IMAGE})" ]
    then
	echo "Missing IMAGE=${IMAGE}" &&
	exit 64 &&
	true
    elif [ -z "${NAME}" ]
    then
	echo Unspecified NAME &&
	    exit 64 &&
	    true
    fi &&
    if [ -z "$(docker container ls --quiet --all --filter name=${NAME})" ]
    then
	docker \
	    container \
	    create \
	    --name "${NAME}" \
	    --restart always \
	    "${IMAGE}" \
	    "${ARGUMENTS}" &&
    fi &&
    true
