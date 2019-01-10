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
    --image)
      IMAGE="${2}" &&
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
  mkdir "${TEMP_DIR}/mount" &&
  fuseiso "${IMAGE}" "${TEMP_DIR}/mount" &&
  mkdir "${TEMP_DIR}/work" &&
  gpg --output "${TEMP_DIR}/work/${DESTINATION}.tar.gz" --decrypt "${TEMP_DIR}/mount/${DESTINATION}.tar.gz.gpg" &&
  gunzip --to-stdout "${TEMP_DIR}/work/${DESTINATION}.tar.gz" > "${TEMP_DIR}/work/${DESTINATION}.tar" &&
  mkdir "${TEMP_DIR}/target" &&
  tar --extract --file "${TEMP_DIR}/work/${DESTINATION}.tar" --directory "${TEMP_DIR}/target" &&
  true
