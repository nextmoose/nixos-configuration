#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--canonical-remote)
	    CANONICAL_REMOTE="${2}" &&
		shift 2 &&
		true
	    ;;
	--branch)
	    BRANCH="${2}" &&
		shift 2 &&
		true
	    ;;
	--private-gpg-file)
	    PRIVATE_GPG_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--private-gpg2-file)
	    PRIVATE_GPG2_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--ownertrust-gpg-file)
	    OWNERTRUST_GPG_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	--ownertrust-gpg2-file)
	    OWNERTRUST_GPG2_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 64
	    ;;
    esac &&
	true
done &&
    TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	if [ -d "${WORK_DIR}/backup" ]
	then
	    /run/wrappers/bin/sudo \
		rsync \
		--archive \
		--delete \
		"${TEMP_DIR}/bacup/configuration.nix" \
		"/etc/nixos" &&
		/run/wrappers/bin/sudo \
		    rsync \
		    --archive \
		    --delete \
		    "${TEMP_DIR}/backup/custom" \
		    "/etc/nixos" &&
		export PATH=/run/wrappers/bin:/run/current-system/sw/bin:$(dirname $(which systemctl)):$(dirname $(which grep)) &&
		sudo nixos-rebuild switch &&
		true
	elif [ -z "${PRIVATE_GPG_FILE}" ]
	then
	    echo Unspecified PRIVATE_GPG_FILE &&
		exit 64 &&
		true
	elif [ ! -f "${PRIVATE_GPG_FILE}" ]
	then
	    echo "PRIVATE_GPG_FILE=${PRIVATE_GPG_FILE} does not exist" &&
		exit 64 &&
		true
	elif [ -z "${PRIVATE_GPG2_FILE}" ]
	then
	    echo Unspecified PRIVATE_GPG2_FILE &&
		exit 64 &&
		true
	elif [ ! -f "${PRIVATE_GPG2_FILE}" ]
	then
	    echo "PRIVATE_GPG2_FILE=${PRIVATE_GPG2_FILE} does not exist" &&
		exit 64 &&
		true
	elif [ -z "${OWNERTRUST_GPG_FILE}" ]
	then
	    echo Unspecified OWNERTRUST_GPG_FILE &&
		exit 64 &&
		true
	elif [ ! -f "${OWNERTRUST_GPG_FILE}" ]
	then
	    echo "OWNERTRUST_GPG_FILE=${OWNERTRUST_GPG_FILE} does not exist" &&
		exit 64 &&
		true
	elif [ -z "${OWNERTRUST_GPG2_FILE}" ]
	then
	    echo Unspecified OWNERTRUST_GPG2_FILE &&
		exit 64 &&
		true
	elif [ ! -f "${OWNERTRUST_GPG2_FILE}" ]
	then
	    echo "OWNERTRUST_GPG2_FILE=${OWNERTRUST_GPG2_FILE} does not exist" &&
		exit 64 &&
		true
	fi &&
	    rm --recursive --force "${TEMP_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    sh "${STORE_DIR}/src/configure-nixos.sh" \
       --canonical-remote "${CANONICAL_REMOTE}" \
       --branch "${BRANCH}" \
       --work-dir "${TEMP_DIR}" \
       --config-dir /etc/nixos \
       --private-gpg-file "${PRIVATE_GPG_FILE}" \
       --private-gpg2-file "${PRIVATE_GPG2_FILE}" \
       --ownertrust-gpg-file "${OWNERTRUST_GPG_FILE}" \
       --ownertrust-gpg2-file "${OWNERTRUST_GPG2_FILE}" &&
    export PATH=/run/wrappers/bin:/run/current-system/sw/bin:$(dirname $(which systemctl)):$(dirname $(which grep)) &&
    sudo nixos-rebuild switch &&
    true
