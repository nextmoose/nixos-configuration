#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--dot-ssh)
	    DOT_SSH="${2}" &&
		shift 2 &&
		true
	    ;;
	--password-store-dir)
	    export PASSWORD_STORE_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	--gnupghome)
	    export GNUPGHOME="${2}" &&
		shift 2 &&
		true
	    ;;
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
    if [ -z "${DOT_SSH}" ]
    then
	echo Unspecified DOT_SSH &&
	    exit 64 &&
	    true
    elif [ ! -d "${DOT_SSH}" ]
    then
	echo "Specified directory DOT_SSH=${DOT_SSH} does not exist" &&
	    exit 64 &&
	    true
    elif [ -z "${PASSWORD_STORE_DIR}" ]
    then
	echo Unspecified PASSWORD_STORE_DIR &&
	    exit 64 &&
	    true
    elif [ ! -d "${PASSWORD_STORE_DIR}" ]
    then
	echo "Specified PASSWORD_STORE_DIR=${PASSWORD_STORE_DIR} does not exist" &&
	    exit 64 &&
	    true
    elif [ -z "${GNUPGHOME}" ]
    then
	echo Unspecified GNUPGHOME &&
	    exit 64 &&
	    true
    elif [ ! -d "${GNUPGHOME}" ]
    then
	echo "Specified GNUPGHOME=${GNUPGHOME} does not exist" &&
	    exit 64 &&
	    true
    elif [ -z "${HOST}" ]
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
	-e "s#\${DOT_SSH}#${DOT_SSH}#" \
	-e "w${DOT_SSH}/${DOMAIN}.conf" \
	"${STORE_DIR}/config" &&
    pass show "${DOMAIN}.id_rsa" > "${DOT_SSH}/${DOMAIN}.id_rsa" &&
    pass show "${DOMAIN}.known_hosts" > "${DOT_SSH}/${DOMAIN}.known_hosts" &&
    chmod \
	0400 \
	"${DOT_SSH}/${DOMAIN}.conf" \
	"${DOT_SSH}/${DOMAIN}.id_rsa" \
	"${DOT_SSH}/${DOMAIN}.known_hosts" &&
    true
