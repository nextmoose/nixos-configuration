#!/bin/sh
# needs fuseiso
while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --destination)
      DESTINATION="${2}" &&
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
  cleanup() {
    rm --recursive --force "${TEMP_DIR}" &&
      true
  } &&
  trap cleanup EXIT &&
  aws s3 cp s3://${BUCKET}/${DESTINATION}.tar.gz.gpg.iso "${TEMP_DIR}" &&
  xorriso -osirrox on -indev "${TEMP_DIR}/${DESTINATION}.tar.gz.gpg.iso" -extract / "${TEMP_DIR}" &&
  gpg --output "${TEMP_DIR}/${DESTINATION}.tar.gz" --decrypt "${TEMP_DIR}/${DESTINATION}.tar.gz.gpg" &&
  gunzip --to-stdout "${TEMP_DIR}/${DESTINATION}.tar.gz" > "${TEMP_DIR}/${DESTINATION}.tar" &&
  tar --extract --file "${TEMP_DIR}/${DESTINATION}.tar" --directory "${HOME}" &&
  true
