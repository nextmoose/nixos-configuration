#!/bin/sh

docker image ls --no-trunc --quiet --filter "label=uuid=${@}" &&
    true
