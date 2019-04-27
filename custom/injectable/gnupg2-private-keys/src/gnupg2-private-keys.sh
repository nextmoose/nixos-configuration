#!/bin/sh

gpg2 --batch --import "${STORE_DIR}/gnupg2-private-keys.asc" &&
    true
