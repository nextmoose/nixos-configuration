#!/bin/sh

gpg --import-ownertrust "${STORE_DIR}/gnupg-ownertrust.asc" &&
    true
