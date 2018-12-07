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
      dot-ssh \
      --upstream-host "${UPSTREAM_HOST}" \
      --upstream-user "${UPSTREAM_USER}" \
      --upstream-port "${UPSTREAM_PORT}" \
      --origin-host "${ORIGIN_HOST}" \
      --origin-user "${ORIGIN_USER}" \
      --origin-port "${ORIGIN_PORT}" &&
      mkdir "${HOME}/project" &&
      git -C "${HOME}/project" init &&
      git -C "${HOME}/project" config user.name "Emory Merryman" &&
      git -C "${HOME}/project" config user.email "emory.merryman@gmail.com" &&
      git -C "${HOME}/project" remote add upstream "upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
      git -C "${HOME}/project" remote add upstream "upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
      git -C "${HOME}/project" fetch upstream "${UPSTREAM_BRANCH}" &&
      git -C "${HOME}/project" checkout "upstream/${UPSTREAM_BRANCH}" &&
      ln --symbolic "$(which post-commit)" "${HOME}/project/.git/hooks" &&
      touch "${HOME}/.finger" &&
      sleep-forever &&
      true
  fi &&
true
