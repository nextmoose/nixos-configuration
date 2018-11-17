#!/bin/sh

makeWrapper "${TARGET_DIR}/scripts/hello.sh" "${TARGET_DIR}/bin/hello" --set PATH [ coreutils ] &&
    true
