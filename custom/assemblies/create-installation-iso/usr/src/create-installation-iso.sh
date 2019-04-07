#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
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
if [ -z "${GPG_SECRET_KEYS_FILE}" ]
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
read -s -p "SYMMETRIC PASSPHRASE? " SYMMETRIC_PASSPHRASE &&
cp "${STORE_DIR}/etc/nixos-live/iso.nix" "${TEMP_DIR}" &&
cd "${TEMP_DIR}" &&
nix-build "<nixpkgs/nixos>" -A config.system.build.isoImage -I nixos-config=iso.nix &&
true
