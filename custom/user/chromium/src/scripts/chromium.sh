#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --env DISPLAY \
    --shm-size=256m \
    --mount type=bind,source=/etc/machine-id,destination=/etc/machine-id,readonly=true \
    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
    --mount type=bind,source=/run/dbus/system_bus_socket,destination=/run/dbus/system_bush_socket,readonly=true \
    --privileged \
    chromium \
    true
#     urgemerge/chromium-pulseaudio &&

