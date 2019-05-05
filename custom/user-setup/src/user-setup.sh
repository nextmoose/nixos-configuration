#!/bin/sh

docker image load --input "${STORE_DIR}/images/read-only-pass.tar" --quiet &&
    true
