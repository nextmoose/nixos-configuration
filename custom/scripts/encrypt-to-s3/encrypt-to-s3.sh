#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --name)
      NAME="${2}" &&
        shift 2 &&
        true
    ;;
    --source-directory)
      SOURCE_DIRECTORY="${2}" &&
        shift 2 &&
        true
    ;;
    --source)
      SOURCE="${2}" &&
        shift 2 &&
        true
    ;;
    --bucket)
      BUCKET="${2}" &&
        shift 2 &&
        true
    ;;
    *)
      echo "Unknown Option" &&
        echo "${1}" &&
        echo "${@}" &&
        echo "${0}" &&
        exit 66 &&
        true
    ;;
  esac &&
    true
done &&
  TEMP_DIR=$(mktemp -d) &&
  echo ${TEMP_DIR} &&
  tar --create --file "${TEMP_DIR}/${NAME}.tar" --directory "${SOURCE_DIRECTORY}" "${SOURCE}" &&
  gzip -9 --to-stdout "${TEMP_DIR}/${NAME}.tar" > "${TEMP_DIR}/${NAME}.tar.gz" &&
  gpg --output "${TEMP_DIR}/${NAME}.tar.gz.gpg" --sign --encrypt --recipient $(gnupg-key-id) "${TEMP_DIR}/${NAME}.tar.gz" &&
  mkisofs -o "${TEMP_DIR}/${NAME}.tar.gz.gpg.iso" -R -joliet-long "${TEMP_DIR}/${NAME}.tar.gz.gpg" &&
  dvdisaster --image "${TEMP_DIR}/${NAME}.tar.gz.gpg.iso" -mRS01 --redundancy high --ecc "${TEMP_DIR}/${NAME}.tar.gz.gpg.ecc" --create &&
  true
