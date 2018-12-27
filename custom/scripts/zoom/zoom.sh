#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --shm-size=256m \
    --mount type=bind,source=/home/user,destination=/srv/home,readonly=false \
    --mount type=bind,source=/,destination=/srv/host,readonly=true \
    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
    --mount type=bind,source=/run/user/1000/pulse:/run/user/1000/pulse,readonly=true \
    --mount type=bind,source=/etc/machine-id,destination=/etc/machine-id,readonly=true \
    --mount type=bind,source=/var/run/dbus/system_bus_socket,destination=/var/run/dbus/system_bus_socket,readonly=true \
    --mount type=bind,source=/home/user/.config/pulse,destination=/home/user/.config/pulse,readonly=true \
    --env DISPLAY \
    --privileged \
    zoom
