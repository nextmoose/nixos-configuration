#!/bin/sh

docker \
    container \
    run \
    --detach \
    --env DISPLAY \
    --env CANONICAL_HOST \
    --env CANONICAL_ORGANIZATION \
    --env CANONICAL_REPOSITORY \
    --env CANONICAL_BRANCH \
    --env COMMITTER_NAME \
    --env COMMITTER+EMAIL \
    --env ORIGIN_HOST \
    --env ORIGIN_USER \
    --env ORIGIN_PORT \
    --env ORIGIN_ORGANIZATION \
    --env ORIGIN_REPOSITORY \
    --env ORIGIN_BRANCH \
    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
    --mount type=bind,source=/etc/machine-id,destination=/etc/machine-id,readonly=true \
    atom &&
    true
