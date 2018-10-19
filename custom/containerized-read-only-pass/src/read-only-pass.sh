#!/bin/sh

docker image load < ${STORE_DIR}/etc/result &&
    docker container run --interactive --tty --rm read-only-pass &&
    true
