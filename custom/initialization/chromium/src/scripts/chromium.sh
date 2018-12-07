#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --origin-host)
      ORIGIN_HOST="${2}" &&
        shift 2 &&
        true
     ;;
     --origin-user)
      ORIGIN_USER="${2}" &&
        shift 2 &&
        true
    ;;
    --origin-port)
    ORIGIN_PORT="${2}" &&
      shift 2 &&
      true
   ;;
   --origin-organization)
   ORIGIN_ORGANIZATION="${2}" &&
    shift 2 &&
    true
  ;;
  --origin-repository)
    ORIGIN_REPOSITORY="${2}" &&
      shift 2 &&
      true
  ;;
  --origin-branch)
    ORIGIN_BRANCH="${2}" &&
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
      dot-ssh --origin-host "${ORIGIN_HOST}" --origin-user "${ORIGIN_USER}" --origin-port "${ORIGIN_PORT}" &&
      pass init "$(gnupg-key-id)" &&
      pass git init &&
      pass git remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
      pass git fetch origin "${ORIGIN_BRANCH}" &&
      pass git checkout "origin/${ORIGIN_BRANCH}" &&
      touch "${HOME}/.finger" &&
      true
  fi &&
true
