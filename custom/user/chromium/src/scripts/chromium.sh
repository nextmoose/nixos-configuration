#!/bin/sh

docker \
    container \
    run \
    --privileged \
    --cap-add ALL \
    --interactive \
    --tty \
    --rm \
    --env DISPLAY \
    --shm-size=256m \
    --mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
    --mount type=bind,source=/run/user,destination=/run/user,readonly=true \
    --mount type=bind,source=/etc/machine-id,destination=/etc/machine-id,readonly=true \
    chromium &&
    true
#     urgemerge/chromium-pulseaudio &&

