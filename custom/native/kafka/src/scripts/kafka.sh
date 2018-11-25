#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--broker-id)
	    BROKER_ID="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unknown Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 66 &&
		true
	    ;;
    esac &&
	true
done &&
    sed \
	-e "s#broker.id=0#broker.id=${BROKER_ID}#" \
	-e "w${HOME}/server.conf" ${STORE_DIR}/lib/server.conf && 
    kafka-server-start.sh "${HOME}/server.conf" &&
    true
