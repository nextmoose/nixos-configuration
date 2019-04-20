#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--dot-ssh)
	    DOT_SSH="${2}" &&
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
    fi &&
    chmod 0700 "${DOT_SSH}" &&
    sed \
	-e "s#\${HOME}#${DOT_SSH}#" \
	-e "w${DOT_SSH}/config" \
	"${STORE_DIR}/config" &&
    true
