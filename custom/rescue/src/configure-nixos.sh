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
	--work-dir)
	    WORK_DIR="${2}" &&
		shift 2 &&
		true
	    ;;
	--config-dir)
	    CONFIG_DIR="${2}" &&
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
    if [ -z "${CANONICAL_REMOTE}" ]
    then
	echo Unspecified CANONICAL_REMOTE &&
	    exit 64 &&
	    true
    elif [ -z "${BRANCH}" ]
    then
	echo Unspecified BRANCH &&
	    exit 64 &&
	    true
    elif [ -z "${WORK_DIR}" ]
    then
	echo Unspecified WORK_DIR &&
	    exit 64 &&
	    true
    elif [ ! -d "${WORK_DIR}" ]
    then
	echo "WORK_DIR=${WORK_DIR} does not exist" &&
	    exit 64 &&
	    true
    elif [ -z "${CONFIG_DIR}" ]
    then
	echo Unspecified CONFIG_DIR &&
	    exit 64 &&
	    true
    elif [ ! -d "${CONFIG_DIR}" ]
    then
	echo "CONFIG_DIR=${CONFIG_DIR} does not exist" &&
	    exit 64 &&
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
    read -s -p "USER PASSWORD? " USER_PASSWORD &&
    read -s -p "VERIFY USER PASSWORD? " VERIFY_USER_PASSWORD &&
    if [ -z "${USER_PASSWORD}" ]
    then
	echo Empty USER_PASSWORD &&
	    exit 64 &&
	    true
    elif [ "${USER_PASSWORD}" != "${VERIFY_USER_PASSWORD}" ]
    then
	echo USER_PASSWORD not verified &&
	    exit 64 &&
	    true
    fi &&
    mkdir "${WORK_DIR}/repository" &&
    git -C "${WORK_DIR}/repository" init &&
    git -C "${WORK_DIR}/repository" remote add canonical "${CANONICAL_REMOTE}" &&
    git -C "${WORK_DIR}/repository" fetch --depth 1 canonical "${BRANCH}" &&
    git -C "${WORK_DIR}/repository" archive --prefix nixos-configuration/ --output "${WORK_DIR}/nixos-configuration.tar" "canonical/${BRANCH}" &&
    tar --extract --file "${WORK_DIR}/nixos-configuration.tar" --directory "${WORK_DIR}" &&
    mkdir "${WORK_DIR}/nixos-configuration/custom/derivations/pass/var" &&
    cat "${PRIVATE_GPG_FILE}" > "${WORK_DIR}/nixos-configuration/custom/derivations/pass/var/private.gpg" &&
    cat "${PRIVATE_GPG2_FILE}" > "${WORK_DIR}/nixos-configuration/custom/derivations/pass/var/private.gpg2" &&
    cat "${OWNERTRUST_GPG_FILE}" > "${WORK_DIR}/nixos-configuration/custom/derivations/pass/var/ownertrust.gpg" &&
    cat "${OWNERTRUST_GPG2_FILE}" > "${WORK_DIR}/nixos-configuration/custom/derivations/pass/var/ownertrust.gpg2" &&
    HASHED_USER_PASSWORD="$(echo ${USER_PASSWORD} | mkpasswd --stdin -m sha-512)" &&
    sed \
	-e "s#\${HASHED_USER_PASSWORD}#${HASHED_USER_PASSWORD}#" \
	-e "w${WORK_DIR}/nixos-configuration/custom/password.nix" \
	"${STORE_DIR}/src/password.nix" &&
    mkdir "${WORK_DIR}/backup" &&
    /run/wrappers/bin/sudo \
	mv \
	--force \
	"${CONFIG_DIR}/configuration.nix" \
	"${CONFIG_DIR}/custom" \
	"${WORK_DIR}/backup" &&
    /run/wrappers/bin/sudo \
	rsync \
	--archive \
	--delete \
	"${WORK_DIR}/nixos-configuration/configuration.nix" \
	"${CONFIG_DIR}" &&
    /run/wrappers/bin/sudo \
	rsync \
	--archive \
	--delete \
	"${WORK_DIR}/nixos-configuration/custom" \
	"${CONFIG_DIR}" &&
    true
