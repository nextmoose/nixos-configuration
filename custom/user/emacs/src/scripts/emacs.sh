#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --env DISPLAY \
    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0 \
    emacs &&
    true
