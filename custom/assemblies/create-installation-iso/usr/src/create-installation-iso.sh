#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
  cleanup() {
    rm --recursive --force "${TEMP_DIR}" &&
      true
  } &&
  trap cleanup EXIT &&
  read -s -p "SYMMETRIC PASSPHRASE? " SYMMETRIC_PASSPHRASE &&
  cp "${STORE_DIR}/etc/nixos-live/iso.nix" "${TEMP_DIR}" &&
  nix-build '<nixpkgs/nixos>' -A "config.system.${TEMP_DIR}.isoImage" -I nixos-config=iso.nix
  true
