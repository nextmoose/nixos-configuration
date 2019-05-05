#!/bin/sh

docker image ls --quiet --filter "label=uuid=${@}" &&
    true
