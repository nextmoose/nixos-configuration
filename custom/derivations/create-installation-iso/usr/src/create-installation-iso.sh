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
    fi &&
    read -s -p "LUKS PASSPHRASE? " LUKS_PASSPHRASE &&
    read -s -p "VERIFY LUKS PASSPHRASE? " VERIFY_LUKS_PASSPHRASE &&
    if [ -z "${LUKS_PASSPHRASE}" ]
    then
	echo Empty LUKS_PASSPHRASE &&
	    exit 64 &&
	    true
    elif [ "${LUKS_PASSPHRASE}" != "${VERIFY_LUKS_PASSPHRASE}" ]
    then
	echo LUKS_PASSPHRASE not verified &&
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
    pass show private.gpg > "${WORK_DIR}/nixos-configuration/custom/derivations/pass/var/private.gpg" &&
    pass show private.gpg2 > "${WORK_DIR}/nixos-configuration/custom/derivations/pass/var/private.gpg2" &&
    pass show ownertrust.gpg > "${WORK_DIR}/nixos-configuration/custom/derivations/pass/var/ownertrust.gpg" &&
    pass show ownertrust.gpg2 > "${WORK_DIR}/nixos-configuration/custom/derivations/pass/var/ownertrust.gpg2" &&
    HASHED_USER_PASSWORD="$(echo ${USER_PASSWORD} | mkpasswd --stdin -m sha-512)" &&
    sed \
	-e "s#\${HASHED_USER_PASSWORD}#${HASHED_USER_PASSWORD}#" \
	-e "w${WORK_DIR}/nixos-configuration/custom/password.nix" \
	"${STORE_DIR}/etc/password.nix" &&
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
while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --configuration-directory)
      CONFIGURATION_DIRECTORY="${2}" &&
        shift 2 &&
        true
      ;;
    --gpg-secret-keys-file)
      GPG_SECRET_KEYS_FILE="${2}" &&
        shift 2 &&
        true
      ;;
    --gpg-ownertrust-file)
      GPG_OWNERTRUST_FILE="${2}" &&
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
if [ -z "${CONFIGURATION_DIRECTORY}" ]
then
  echo Unspecified CONFIGURATION_DIRECTORY &&
    exit 64 &&
    true
elif [ ! -d "${CONFIGURATION_DIRECTORY}" ]
then
  echo "Missing CONFIGURATION_DIRECTORY=${CONFIGURATION_DIRECTORY}" &&
    exit 64 &&
    true
elif [ -z "${GPG_SECRET_KEYS_FILE}" ]
then
  echo Unspecified GPG_SECRET_KEYS_FILE &&
    exit 64 &&
    true
elif [ ! -f "${GPG_SECRET_KEYS_FILE}" ]
then
  echo "Missing GPG_SECRET_KEYS_FILE=${GPG_SECRET_KEYS_FILE} file" &&
    exit 64 &&
    true
elif [ -z "${GPG_OWNERTRUST_FILE}" ]
then
  echo Unspecified GPG_OWNERTRUST_FILE &&
    exit 64 &&
    true
elif [ ! -f "${GPG_OWNERTRUST_FILE}" ]
then
  echo "Missing GPG_OWNERTRUST_FILE=${GPG_OWNERTRUST_FILE} file" &&
    exit 64 &&
    true
fi &&
TEMP_DIR=$(mktemp -d) &&
cleanup() {
  cd ${TEMP_DIR} &&
    cat iso.nix &&
    rm --recursive --force "${TEMP_DIR}" &&
    true
} &&
trap cleanup EXIT &&
cp "${STORE_DIR}/etc/nixos-live/iso.nix" "${TEMP_DIR}" &&
mkdir "${TEMP_DIR}/secrets" &&
cat "${GPG_SECRET_KEYS_FILE}" > "${TEMP_DIR}/secrets/private.gpg.asc" &&
cat "${GPG_OWNERTRUST_FILE}" > "${TEMP_DIR}/secrets/ownertrust.gpg.asc" &&
chmod 0400 "${TEMP_DIR}/secrets/private.gpg.asc" "${TEMP_DIR}/secrets/ownertrust.gpg.asc" &&
tar --create --file "${TEMP_DIR}/secrets.tar" --directory "${TEMP_DIR}" secrets &&
gzip -9 --to-stdout "${TEMP_DIR}/secrets.tar" > "${TEMP_DIR}/secrets.tar.gz" &&
gpg --armor --output "${TEMP_DIR}/secrets.tar.gz.gpg" --symmetric "${TEMP_DIR}/secrets.tar.gz" &&
mkdir "${TEMP_DIR}/nixos-live" &&
cat "${STORE_DIR}/etc/nixos-live/iso.nix" > "${TEMP_DIR}/nixos-live/iso.nix" &&
cp --recursive "${CONFIGURATION_DIRECTORY}" "${TEMP_DIR}/configuration" &&
cd "${TEMP_DIR}" &&
nix-build "<nixpkgs/nixos>" -A config.system.build.isoImage -I "nixos-config=${TEMP_DIR}/configuration/iso.nix" &&
true
