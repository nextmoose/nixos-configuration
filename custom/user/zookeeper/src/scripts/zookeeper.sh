#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    zookeeper
