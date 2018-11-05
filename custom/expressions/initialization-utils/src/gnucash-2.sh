#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--gnucash)
	    GNUCASH="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 65 &&
		true
	    ;;
    esac &&
	true
done &&
        (cat <<EOF
GNUCASH
EOF
    ) | while read VAR do
    do
	eval VAL=\${${VAR}} &&
	    if [ -z "${VAL}" ]
	    then
		echo Undefined ${VAR} &&
		    echo ${0} &&
		    exit 66 &&
		    true
	    fi &&
	    true
    done &&
    if [ -f ${HOME}/.gconf.path ]
    then
	gnucash "${GNUCASH}" &&
	    true
    else
	cp ${STORE_DIR}/lib/gconf.path ${HOME}/.gconf.path &&
	    gconftool-2 --shutdown &&
	    true
    fi &&
    true
