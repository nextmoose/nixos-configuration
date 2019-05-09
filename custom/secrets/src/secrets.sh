#!/bin/sh

docker \
    container \
    exec \
    --interactive \
    --tty \
    $(docker container ls --quiet --filter "label=uuid=${UUID}" --no-trunc) \
    pass \
    ${@} &&
    true
