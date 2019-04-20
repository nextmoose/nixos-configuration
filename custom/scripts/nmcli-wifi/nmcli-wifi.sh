#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --ssid)
      SSID="${2}" &&
        shift 2 &&
        true
    ;;
    --password)
      PASSWORD="${2}" &&
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
  /run/wrappers/bin/sudo nmcli device wifi connect "${SSID}" password "${PASSWORD}" &&
  true
