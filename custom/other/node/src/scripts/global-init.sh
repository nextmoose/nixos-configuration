#!/bin/sh

echo "prefix=${STORE_DIR}/npm-packages" > "${HOME}/.npmrc" &&
  echo "${STORE_DIR}" &&
  true
