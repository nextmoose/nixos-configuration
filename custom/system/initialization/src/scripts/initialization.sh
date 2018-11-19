#!/bin/sh

echo ALPHA 00100 &&
    xhost +local: &&
    echo ALPHA 00200 &&
    docker-image-load emacs &&
    echo ALPHA 00300 &&
    true
