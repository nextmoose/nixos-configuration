#!/bin/sh

jq -r . ${STORE_DIR}/configuration.json &&
    gpg --batch --import $(jq -r .gpg.key ${STORE_DIR}/configuration.json) &&
    gpg --import-ownertrust $(jq -r .gpg.ownertrust ${STORE_DIR}/configuration.json) &&
    gpg2 --import $(jq -r .gpg2.key ${STORE_DIR}/configuration.json) &&
    gpg2 --import-ownertrust $(jq -r .gpg2.ownertrust ${STORE_DIR}/configuration.json) &&
    true
