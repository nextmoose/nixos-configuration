#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --mount type=bind,source=/home/user,destination=/srv/home,readonly=false \
    --mount type=bind,source=/,destination=/srv/host,readonly=true \
    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
    --env DISPLAY \
    --privileged \
    zoom
