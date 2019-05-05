#!/bin/sh

docker container ls --quiet --filter "label=uuid=${@}" &&
    true
