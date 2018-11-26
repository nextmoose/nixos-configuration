#!/bin/sh

case "${1}" in
    kafka-server-start)
	shift &&
	    kafka-server-start "${@}" &&
	    true
	;;
    kafka-topics)
	shift &&
	    kafka-topics "${@}" &&
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
