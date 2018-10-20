#!/bin/sh

cd $(mktemp -d) &&
    cp ${STORE_DIR}/etc/chromium.nix . &&
    /run/current-system/sw/bin/nix-build chromium.nix &&
    docker image load < result &&
    docker \
	container \
	run \
	--interactive \
	--tty \
	--rm \
	--mount type=bind,src=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
	--mount type=bind,src=/etc/machine-id,destination=/etc/machine-id,readonly=true \
	--mount type=bind,src=/run/dbus/system_bus_socket,destination=/run/dbus/system_bus_socket,readonly=true \
	--mount type=bind,src=/tmp,destination=/tmp \
	--privileged \
	--env DISPLAY \
	chromium
