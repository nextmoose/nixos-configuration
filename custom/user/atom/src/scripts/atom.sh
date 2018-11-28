#!/bin/sh

docker \
    container \
    run \
    --detach \
    --env DISPLAY \
    --env COMMITTER_NAME \
    --env COMMITTER+EMAIL \
    --env UPSTREAM_HOST \
    --env UPSTREAM_USER \
    --env UPSTREAM_PORT \
    --env UPSTREAM_ORGANIZATION \
    --env UPSTREAM_REPOSITORY \
    --env UPSTREAM_BRANCH \
    --env ORIGIN_HOST \
    --env ORIGIN_USER \
    --env ORIGIN_PORT \
    --env ORIGIN_ORGANIZATION \
    --env ORIGIN_REPOSITORY \
    --env ORIGIN_BRANCH \
    --env REPORT_HOST \
    --env REPORT_USER \
    --env REPORT_PORT \
    --env REPORT_ORGANIZATION \
    --env REPORT_REPOSITORY \
    --env REPORT_BRANCH \
    --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0,readonly=true \
    --mount type=bind,source=/etc/machine-id,destination=/etc/machine-id,readonly=true \
    atom &&
    true
