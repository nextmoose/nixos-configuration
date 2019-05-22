#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--host)
	    HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--host-name)
	    HOST_NAME="${2}" &&
		shift 2 &&
		true
	    ;;
	--user)
	    USER="${2}" &&
		shift 2 &&
		true
	    ;;
	--id-rsa)
	    ID_RSA="${2}" &&
		shift 2 &&
		true
	    ;;
	--known-hosts)
	    KNOWN_HOSTS="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		true
	    ;;
    esac &&
	true
done &&
    if [ -z "${HOST}" ]
    then
	echo Unspecified HOST &&
	    exit 64 &&
	    true
    elif [ -z "${HOST_NAME}" ]
    then
	echo Unspecified HOST_NAME &&
	    exit 64 &&
	    true
    elif [ -z "${USER}" ]
    then
	echo Unspecified USER &&
	    exit 64 &&
	    true
    elif [ -z "${ID_RSA}" ]
    then
	echo Unspecified ID_RSA &&
	    exit 64 &&
	    true
    elif [ -z "${KNOWN_HOSTS}" ]
    then
	echo Unspecified KNOWN_HOSTS &&
	    exit 64 &&
	    true
    fi &&
    sed \
	-e "s#\${HOST}#${HOST}#" \
	-e "s#\${HOST_NAME}#${HOST_NAME}#" \
	-e "s#\${USER}#${USER}#" \
	-e "s#\${HOME}#${HOME}#" \
	-e "w${HOME}/.ssh/${HOST}.conf" \
	"${STORE_DIR}/src/config" &&
    echo "${ID_RSA}" > "${HOME}/.ssh/${HOST}.id_rsa" &&
    echo "${USER_KNOWN_HOSTS}" > "${HOME}/.ssh/${HOST}.known_hosts" &&
    chmod \
	0400 \
	"${HOME}/.ssh/${HOST}.conf" \
	"${HOME}/.ssh/${HOST}.id_rsa" \
	"${HOME}/.ssh/${HOST}.known_hosts" &&
    true
