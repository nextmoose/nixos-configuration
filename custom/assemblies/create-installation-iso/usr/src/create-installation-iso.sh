#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
  cleanup() {
    rm --recursive --force "${TEMP_DIR}" &&
      true
  } &&
  trap cleanup EXIT &&
  read -s -p "SYMMETRIC PASSPHRASE? " SYMMETRIC_PASSPHRASE &&
  cp "${STORE_DIR}/etc/nixos-live" "${TEMP_DIR}/iso.nix" &&
  nix-build '<nixpkgs/nixos>' -A config.system.${DESTDIR}.isoImage -I nixos-config=iso.nix
  true
