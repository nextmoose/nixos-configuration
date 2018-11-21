#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --publish-all \
    node-push-runner &&
    true
