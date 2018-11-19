#!/bin/sh

xhost +local: &&
    docker-image-load emacs &&
    true
