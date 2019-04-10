#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --canonical-remote)
      CANONICAL_REMOTE="${2}" &&
        shift 2 &&
        true
    ;;
    --branch)
      BRANCH="${2}" &&
        shift 2 &&
        true
    ;;
    *)
      echo Unsupported Option &&
        echo "${1}" &&
        echo "${0}" &&
        echo "${@}" &&
        exit 64
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
  read -s -p "USER PASSWORD? " USER_PASSWORD &&
  read -s -p "VERIFY USER PASSWORD? " VERIFY_USER_PASSWORD &&
  if [ -z "${USER_PASSWORD}" ]
  then
    echo Empty USER_PASSWORD &&
      exit 64 &&
      true
  elif [ "${USER_PASSWORD}" != "${VERIFY_USER_PASSWORD}" ]
  then
    echo USER_PASSWORD not verified &&
      exit 64 &&
      true
  fi &&
  mkdir "${TEMP_DIR}/repository"
  git -C "${TEMP_DIR}/repository" init &&
  git -C "${TEMP_DIR}/repository" remote add "${CANONICAL_REMOTE}" &&
  git -C "${TEMP_DIR}/repository" fetch --depth 1 "${CANONICAL_REMOTE}" "${BRANCH}" &&
  git -C "${TEMP_DIR}/repository" archive --prefix nixos-configuration --output "${TEMP_DIR}/nixos-configuration.tar" &&
  tar --extract --file "${TEMP_DIR}/nixos-configuration.tar" --directory "${TEMP_DIR}" &&
  mkdir "${TEMP_DIR}/nixos-configuration/custom/derivations/pass/var" &&
  pass show private.gpg > "${TEMP_DIR}/nixos-configuration/custom/derivations/pass/var/private.gpg" &&
  pass show ownertrust.gpg > "${TEMP_DIR}/nixos-configuration/custom/derivations/pass/var/ownertrust.gpg" &&
  HASHED_USER_PASSWORD="$(echo ${USER_PASSWORD} | mkpasswd --stdin -m sha-512)" &&
  sed \
    -e "s#\${HASHED_USER_PASSWORD}##" \
    -e "w${TEMP_DIR}/nixos-configuration/custom/password.nix" \
    "${STORE_DIR}/etc/install-local-nixos/password.nix" &&
  /run/wrappers/bin/sudo \
    rm \
    --recursive \
    --force \
    /etc/nixos/configuration.nix \
    /etc/nixos/custom &&
  /run/wrappers/bin/sudo \
    rsync \
    --archive \
    --delete \
    "${TEMP_DIR}/nixos-configuration/configuration.nix" \
    /etc/nixos &&
    /run/wrappers/bin/sudo \
      rsync \
      --archive \
      --delete \
      "${TEMP_DIR}/nixos-configuration/custom" \
      /etc/nixos &&
    true
