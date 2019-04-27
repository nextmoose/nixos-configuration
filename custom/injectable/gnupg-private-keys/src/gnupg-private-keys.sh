#!/bin/sh

gpg --batch --import "${STORE_DIR}/gnupg-private-keys.asc" &&
    true
