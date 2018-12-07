#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --upstream-host)
      UPSTREAM_HOST="${2}" &&
        shift 2 &&
        true
     ;;
     --upstream-user)
      UPSTREAM_USER="${2}" &&
        shift 2 &&
        true
    ;;
    --upstream-port)
    UPSTREAM_PORT="${2}" &&
      shift 2 &&
      true
   ;;
   --upstream-organization)
   UPSTREAM_ORGANIZATION="${2}" &&
    shift 2 &&
    true
  ;;
  --upstream-repository)
    UPSTREAM_REPOSITORY="${2}" &&
      shift 2 &&
      true
  ;;
  --upstream-branch)
    UPSTREAM_BRANCH="${2}" &&
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
      dot-ssh --upstream-host "${UPSTREAM_HOST}" --upstream-user "${UPSTREAM_USER}" --upstream-port "${UPSTREAM_PORT}" &&
      pass init "$(gnupg-key-id)" &&
      pass git init &&
      pass git remote add upstream "upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
      pass git fetch upstream "${UPSTREAM_BRANCH}" &&
      pass git checkout "upstream/${UPSTREAM_BRANCH}" &&
      touch "${HOME}/.finger" &&
      true
  fi &&
true
