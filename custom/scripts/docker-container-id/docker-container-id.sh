#!/bin/sh

docker container ls --no-trunc --quiet --filter "label=uuid=${@}" &&
    true
