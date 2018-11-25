#!/bin/sh

TOPICS=() &&
    LIST_TOPICS="no" &&
    while [ "${#}" -gt 0 ]
    do
	case "${1}" in
	    --broker-id)
		BROKER_ID="${2}" &&
		    shift 2 &&
		    true
		;;
	    --add-topic)
		TOPICS+=("${2}") &&
		    shift 2 &&
		    true
		;;
	    --list-topics)
		LIST_TOPICS="yes" &&
		    shift &&
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
    for TOPIC in ${TOPICS[*]}
    do
	kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic ${TOPIC} &&
	    true
    done &&
    if [ "${LIST_TOPICS}" == "yes" ]
    then
	echo THIS IS A LIST OF THE TOPICS &&
	    kafka-topics.sh --list --zookeeper zookeeper:2181 &&
	    true
    fi &&
    true
