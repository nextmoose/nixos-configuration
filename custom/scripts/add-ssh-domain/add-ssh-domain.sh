#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--domain)
	    DOMAIN="${2}" &&
		shift 2 &&
		true
	    ;;
	--host)
	    HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--user)
	    USER="${2}" &&
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
    elif [ -z "${USER}" ]
    then
	echo Unspecified USER &&
	    exit 64 &&
	    true
    fi &&
    sed \
	-e "s#\${DOMAIN}#${DOMAIN}#" \
	-e "s#\${HOST}#${HOST}#" \
	-e "s#\${USER}#${USER}#" \
	-e "s#\${HOME}#${HOME}#" \
	-e "w${HOME}/.ssh/${DOMAIN}.conf" \
	"${STORE_DIR}/config" &&
    pass show "${DOMAIN}.id_rsa" > "${HOME}/.ssh/${DOMAIN}.id_rsa" &&
    pass show "${DOMAIN}.known_hosts" > "${HOME}/.ssh/${DOMAIN}.known_hosts" &&
    chmod \
	0400 \
	"${HOME}/.ssh/${DOMAIN}.conf" \
	"${HOME}/.ssh/${DOMAIN}.id_rsa" \
	"${HOME}/.ssh/${DOMAIN}.known_hosts" &&
    true
