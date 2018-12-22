#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
    --env DISPLAY \
    read-only-pass \
    --upstream-host github.com \
    --upstream-user git \
    --upstream-port 22 \
    --upstream-organization desertedscorpion \
    --upstream-repository \
    passwordstore \
    --upstream-branch master &&
    true
