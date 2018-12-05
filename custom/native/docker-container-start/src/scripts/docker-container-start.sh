#!/bin/sh

X11="";
while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --image)
      IMAGE="${2}" &&
        shift 2 &&
        true
    ;;
    --name)
      NAME="${2}" &&
      shift 2 &&
      true
  ;;
    *)
      echo "Unknown Option" &&
        echo "${1}" &&
        echo "${0}" &&
        echo "${@}" &&
        exit 66 &&
        true
    ;;
  esac &&
    true
done &&
  CID=$(docker container create --interactive --tty --rm --name "${NAME}" "${@}") &&
  echo DO IT ... docker container start --interactive "${CID}" &&
  docker container start --interactive "${CID}" &&
  true
