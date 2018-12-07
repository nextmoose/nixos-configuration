#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --bucket)
      BUCKET="${2}" &&
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
  if [ ! -f "${HOME}/.finger" ]
  then
    gnupg &&
      cp ${STORE_DIR}/lib/gconf.path ${HOME}/.gconf.path &&
      gconftool-2 --shutdown
      touch "${HOME}/.finger" &&
      true
  fi &&
true
