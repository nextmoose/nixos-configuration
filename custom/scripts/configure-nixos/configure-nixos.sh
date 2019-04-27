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
    fi &&
    read -s -p "USER PASSWORD? " USER_PASSWORD &&
    echo &&
    read -s -p "VERIFY USER PASSWORD? " VERIFY_USER_PASSWORD &&
    echo &&
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
    
    pass show private.gpg > "${WORK_DIR}/nixos-configuration/custom/injectable/gnupg-private-keys/src/gnupg-private-keys.asc" &&
    pass show private.gpg2 > "${WORK_DIR}/nixos-configuration/custom/injectable/gnupg2-private-keys/src/gnupg2-private-keys.asc" &&
    pass show ownertrust.gpg > "${WORK_DIR}/nixos-configuration/custom/injectable/gnupg-ownertrust/src/gnupg-ownertrust.asc" &&
    pass show ownertrust.gpg2 > "${WORK_DIR}/nixos-configuration/custom/injectable/gnupg2-ownertrust/src/gnupg2-ownertrust.asc" &&

    mkdir "${WORK_DIR}/nixos-configuration/custom/scripts/pass/secrets" &&
    pass show private.gpg > "${WORK_DIR}/nixos-configuration/custom/scripts/pass/secrets/private.gpg" &&
    pass show private.gpg2 > "${WORK_DIR}/nixos-configuration/custom/scripts/pass/secrets/private.gpg2" &&
    pass show ownertrust.gpg > "${WORK_DIR}/nixos-configuration/custom/scripts/pass/secrets/ownertrust.gpg" &&
    pass show ownertrust.gpg2 > "${WORK_DIR}/nixos-configuration/custom/scripts/pass/secrets/ownertrust.gpg2" &&
    HASHED_USER_PASSWORD="$(echo ${USER_PASSWORD} | mkpasswd --stdin -m sha-512)" &&
    sed \
	-e "s#\${HASHED_USER_PASSWORD}#${HASHED_USER_PASSWORD}#" \
	-e "w${WORK_DIR}/nixos-configuration/custom/password.nix" \
	"${STORE_DIR}/password.nix" &&
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
