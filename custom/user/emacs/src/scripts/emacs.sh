#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --env DISPLAY \
    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
    --mount type=bind,source=/etc/machine-id,destination=/etc/machine-id,readonly=true \
    emacs &&
    true
