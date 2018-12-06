#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
  cleanup() {
    rm --recursive --force "${TEMP_DIR}" &&
      true
  } &&
  pass show gpg.secret.key > "${TEMP_DIR}/gpg.secret.key" &&
  pass show gpg.owner.trust > "${TEMP_DIR}/gpg.owner.trust" &&
  pass show gpg2.secret.key > "${TEMP_DIR}/gpg2.secret.key" &&
  pass show gpg2.owner.trust > "${TEMP_DIR}/gpg2.owner.trust" &&
  gpg --batch --import "${TEMP_DIR}/gpg.secret.key" &&
  gpg --import-ownertrust "${TEMP_DIR}/gpg.owner.trust" &&
  gpg2 --import "${TEMP_DIR}/gpg2.secret.key" &&
  gpg2 --import-ownertrust "${TEMP_DIR}/gpg2.owner.trust" &&
  true
