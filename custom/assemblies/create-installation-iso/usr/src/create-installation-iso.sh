#!/bin/sh

foo &&
TEMP_DIR=$(mktemp -d) &&
  cleanup() {
    cd ${TEMP_DIR} &&
      cat iso.nix &&
      rm --recursive --force "${TEMP_DIR}" &&
      true
  } &&
  trap cleanup EXIT &&
  read -s -p "SYMMETRIC PASSPHRASE? " SYMMETRIC_PASSPHRASE &&
  cp "${STORE_DIR}/etc/nixos-live/iso.nix" "${TEMP_DIR}" &&
  cd "${TEMP_DIR}" &&
  nix-build "<nixpkgs/nixos>" -A config.system.build.isoImage -I nixos-config=iso.nix &&
  true
