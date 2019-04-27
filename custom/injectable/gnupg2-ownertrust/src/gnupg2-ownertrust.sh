#!/bin/sh

gpg2 --import-ownertrust "${STORE_DIR}/gnupg2-ownertrust.asc" &&
    true
