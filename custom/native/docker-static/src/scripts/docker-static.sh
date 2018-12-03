#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --name)
      NAME="${2}" &&
        shift 2 &&
        true
    ;;
    *)
      echo Unknown Option &&
        echo "${1}" &&
        echo "${0}" &&
        echo "${@}" &&
        exit 66 &&
        true
    ;;
  esac &&
    true
done &&
  cat "${STORE_DIR}/lib/${NAME}" | docker image load &&
  true
