#!/bin/sh

docker \
    container \
    exec \
    --interactive \
    --tty \
    $(docker-container-id "${UUID}") \
    pass \
    ${@} &&
    true
