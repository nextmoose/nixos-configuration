#!/bin/sh

TEMP_DIR="$(mktemp -d)" &&
  cleanup() {
    rm --recursive --force "${TEMP_DIR}" &&
      true
  } &&
  trap cleanup EXIT &&
  gpg --output "${TEMP_DIR}/secrets.tar.gz" "${STORE_DIR}/etc/secrets.tar.gz.gpg" &&
  gunzip "${TEMP_DIR}/secrets.tar.gz" > "${TEMP_DIR}/secrets.tar" &&
  tar --extract --file "${TEMP_DIR}/secrets.tar" --directory "${TEMP_DIR}" &&
  export LUKS_PASSPHRASE="$(pass show luks-passphrase)" &&
  export HASHED_USER_PASSWORD=$(pass show hashed-user-passphrase) &&
