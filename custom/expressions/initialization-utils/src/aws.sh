#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--aws-access-key-id)
	    AWS_ACCESS_KEY_ID="${2}" &&
		shift 2 &&
		true
	    ;;
	--default-region-name)
	    DEFAULT_REGION_NAME="${2}" &&
		shift 2 &&
		true
	    ;;
	--default-output-format)
	    DEFAULT_OUTPUT_FORMAT="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unknown Option &&
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
AWS_ACCESS_KEY_ID
DEFAULT_REGION_NAME
DEFAULT_OUTPUT_FORMAT
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
    if [ ! -d "${HOME}/.aws" ]
    then
	AWS_lsSECRET_ACCESS_KEY="$(pass show ${AWS_ACCESS_KEY_ID})" &&
	    (cat <<EOF
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${DEFAULT_REGION_NAME}
${DEFAULT_OUTPUT_FORMAT}
EOF
	    ) | aws configure &&
	    true
    fi &&
    true
