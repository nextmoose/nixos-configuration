#!/bin/sh

init-dot-ssh &&
    mkdir project &&
    git -C project init &&
    bash &&
    true
