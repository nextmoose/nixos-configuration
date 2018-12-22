#!/bin/sh

docker \
    container \
    run \
    --detach \
    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
    --env DISPLAY \
    emacs \
    --committer-name "Emory Merryman" \
    --committer-email "emory.merryman@gmail.com" \
    --upstream-host github.com \
    --upstream-user git \
    --upstream-port 22 \
    --upstream-organization rebelplutonium \
    --upstream-repository nixos-configuration \
    --upstream-branch master \
    --origin-host github.com \
    --origin-user git \
    --origin-port 22 \
    --origin-organization nextmoose \
    --origin-repository nixos-configuration \
    --origin-branch level-5 \
    --report-host github.com \
    --report-user git \
    --report-port 22 \
    --report-organization rebelplutonium \
    --report-repository nixos-configuration \
    --report-branch master &&
    true
