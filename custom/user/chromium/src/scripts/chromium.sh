#!/bin/sh

docker \
    container \
    run \
    --privileged \
    --interactive \
    --tty \
    --rm \
    --env DISPLAY \
    --shm-size=256m \
    --mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
    --mount type=bind,source=/run/user/${UID}/pulse,destination=/run/user/${UID}/pulse,readonly=true \
    --mount type=bind,source=/etc/machine-id,destination=/etc/machine-id,readonly=true \
    --mount type=bind,source=/var/run/dbus,destination=/var/run/dbus,readonly=true \
    --mount type=bind,source=/run/dbus,destination=/run/dbus,readonly=true \
    --mount type=bind,source=/var/lib/dbus,destination=/var/lib/dbus,readonly=true \
    chromium &&
    true
#     urgemerge/chromium-pulseaudio &&

