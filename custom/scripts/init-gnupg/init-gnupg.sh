#!/bin/sh

jq -r . ${STORE_DIR}/configuration.json &&
    echo ${STORE_DIR} &&
    echo A 00000 &&
    gpg --batch --import $(jq -r .gpg.key ${STORE_DIR}/configuration.json) &&
    echo A 00100 &&
    gpg --import-ownertrust $(jq -r .gpg.ownertrust ${STORE_DIR}/configuration.json) &&
    echo A 00200 &&
    gpg2 --import $(jq -r .gpg2.key ${STORE_DIR}/configuration.json) &&
    echo A 00300 &&
    gpg2 --import-ownertrust $(jq -r .gpg2.ownertrust ${STORE_DIR}/configuration.json) &&
    echo A 00400 &&
    true
