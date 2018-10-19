#!/bin/sh

cd $(mktemp -d) &&
    cp ${STORE_DIR}/etc/bash.nix . &&
    /run/current-system/sw/bin/nix-build bash.nix &&
    docker image load < result &&
    docker container run --interactive --tty --rm bash
