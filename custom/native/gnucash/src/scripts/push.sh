#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
  cleanup() {
    rm --recursive --force "${TEMP_DIR}" &&
      true
  } &&
  trap cleanup EXIT &&
  tar --create --file "${TEMP_DIR}/gnucash.tar" --directory gnucash . &&
  gzip -9 --to-stdout "${TEMP_DIR}/gnucash.tar" > "${TEMP_DIR}/gnucash.tar.gz" &&
  gpg --output "${TEMP_DIR}/gnucash.tar.gz.gpg" --encrypt "${TEMP_DIR}/gnucash.tar.gz" &&
  mkisofs -o "${TEMP_DIR}/gnucash.tar.gz.gpg.iso" "${TEMP_DIR}/gnucash.tar.gz.gpg" &&
  dvdisaster "${TEMP_DIR}/gnucash.tar.gz.gpg.iso" &&
  true
