#!/bin/sh

if [ "${1}" == "pass" ] && [ "${2}" == "show" ] && [ "${#}" == 3 ]
then
  cat "${SECRETS_DIR}/${3}" &&
    true
else
  echo Unsupported Options &&
    echo "${@}" &&
    echo "${0}" &&
    exit 66 &&
    true
 fi &&
 true
