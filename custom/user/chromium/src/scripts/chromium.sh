#!/bin/sh

docker \
    container \
    run \
    --privileged \
    --cap-add ALL \
    --interactive \
    --tty \
    --rm \
    --env XDG_RUNTIME_DIR \
    --env LD_LIBRARY_PATH \
    --mount type=bind,source=${LD_LIBRARY_PATH},destination=${LD_LIBRARY_PATH},readonly=true \
    --env DISPLAY \
    --shm-size=256m \
    --mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
    --mount type=bind,source=/run/user,destination=/run/user,readonly=true \
    --mount type=bind,source=/etc/machine-id,destination=/etc/machine-id,readonly=true \
    --mount type=bind,source=/var/run/dbus,destination=/var/run/dbus,readonly=true \
    --mount type=bind,source=/run/dbus,destination=/run/dbus,readonly=true \
    --mount type=bind,source=/var/lib/dbus,destination=/var/lib/dbus,readonly=true \
    chromium &&
    true
#     urgemerge/chromium-pulseaudio &&

