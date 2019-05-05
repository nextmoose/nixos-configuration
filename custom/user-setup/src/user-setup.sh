#!/bin/sh

docker image load "${STORE_DIR}/images/read-only-pass.tar" &&
    true
