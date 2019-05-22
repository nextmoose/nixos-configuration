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
    system-secrets-read-only-pass show alpha &&
    USER_PASSWORD="$(system-secrets-read-only-pass show user/password)" &&
    mkdir "${WORK_DIR}/repository" &&
    git -C "${WORK_DIR}/repository" init &&
    git -C "${WORK_DIR}/repository" remote add canonical "${CANONICAL_REMOTE}" &&
    git -C "${WORK_DIR}/repository" fetch --depth 1 canonical "${BRANCH}" &&
    git -C "${WORK_DIR}/repository" archive --prefix nixos-configuration/ --output "${WORK_DIR}/nixos-configuration.tar" "canonical/${BRANCH}" &&
    tar --extract --file "${WORK_DIR}/nixos-configuration.tar" --directory "${WORK_DIR}" &&
    ls -alh "${WORK_DIR}/nixos-configuration" &&
    mkdir "${WORK_DIR}/nixos-configuration/custom/injected" &&
    system-secrets-read-only-pass show gpg.secret.key > "${WORK_DIR}/nixos-configuration/custom/injected/gnupg-private-keys.asc" &&
    system-secrets-read-only-pass show gpg2.secret.key > "${WORK_DIR}/nixos-configuration/custom/injected/gnupg2-private-keys.asc" &&
    system-secrets-read-only-pass show gpg.owner.trust > "${WORK_DIR}/nixos-configuration/custom/injected/gnupg-ownertrust.asc" &&
    system-secrets-read-only-pass show gpg2.owner.trust > "${WORK_DIR}/nixos-configuration/custom/injected/gnupg2-ownertrust.asc" &&

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
