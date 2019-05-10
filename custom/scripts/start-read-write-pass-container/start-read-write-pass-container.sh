#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--key)
	    KEY="${2}" &&
		shift 2 &&
		true
	    ;;
	--data-file)
	    DATA_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--host)
	    HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--id-rsa)
	    ID_RSA="${2}" &&
		shift 2 &&
		true
	    ;;
	--user-known-hosts)
	    USER_KNOWN_HOSTS="${2}" &&
		shift 2 &&
		true
	    ;;
	--user)
	    USER="${2}" &&
		shift 2 &&
		true
	    ;;
	--remote)
	    REMOTE="${2}" &&
		shift 2 &&
		true
	    ;;
	--branch)
	    BRANCH="${2}" &&
		shift 2 &&
		true
	    ;;
	--committer-name)
	    COMMITTER_NAME="${2}" &&
		shift 2 &&
		true
	    ;;
	--committer-email)
	    COMMITTER_EMAIL="${2}" &&
		shift 2 &&
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
    if [ -z "${KEY}" ]
    then
	echo Unspecified KEY &&
	    exit 64 &&
	    true
    elif [ -z "${DATA_FILE}" ]
    then
	echo Unspecified DATA_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${DATA_FILE}" ]
    then
	echo Specified Data File "${DATA_FILE}" does not exist &&
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
    elif [ -z "${REMOTE}" ]
    then
	echo Unspecified REMOTE &&
	    exit 64 &&
	    true
    elif [ -z "${BRANCH}" ]
    then
	echo Unspecified BRANCH &&
	    exit 64 &&
	    true
    elif [ -z "${COMMITTER_NAME}" ]
    then
	echo Unspecified COMMITTER_NAME &&
	    exit 64 &&
	    true
    elif [ -z "${COMMITTER_EMAIL}" ]
    then
	echo Unspecified COMMITTER_EMAIL &&
	    exit 64 &&
	    true
    fi &&
    WORK_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    if [ -z "$(docker-container-id $(uuid-parser --domain containers --key ${KEY} --data-file ${DATA_FILE}))" ]
    then
	CIDFILE="${WORK_DIR}/cid" &&
	    UUID=$(uuid-parser --domain containers --key system-secrets-read-only-pass --data-file "${DATA_FILE}") &&
	    IMAGE_ID=$(docker-image-id $(uuid-parser --domain images --key read-only-pass --data-file "${DATA_FILE}")) &&
	    docker \
		container \
		create \
		--cidfile "${CIDFILE}" \
		--restart always \
		--label "uuid=${UUID}" \
		"${IMAGE_ID}" \
		--remote "${REMOTE}" \
		--branch "${BRANCH}" \
		--committer-name "Emory Merryman" \
		--committer-email "emory.merryman@gmail.com" &&
	    docker-container-start-and-wait-for-healthy --cidfile "${CIDFILE}" &&
	    true
    fi &&
    true
