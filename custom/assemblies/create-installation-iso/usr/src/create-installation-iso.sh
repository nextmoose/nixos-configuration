#!/bin/sh

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
