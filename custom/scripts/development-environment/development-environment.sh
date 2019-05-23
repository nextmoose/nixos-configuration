#!/bin/sh

init-dot-ssh &&
    init-dot-ssh-host \
	--host upstream \
	--host-name github.com \
	--user git &&
    init-dot-ssh-host \
	--host origin \
	--host-name github.com \
	--user git &&
    init-dot-ssh-host \
	--host report \
	--host-name github.com \
	--user git &&
    mkdir project &&
    git -C project init &&
    git -C project remote add upstream upstream:rebelplutonium/nixos-configuration.git &&
    git -C project remote add upstream origin:nextmoose/nixos-configuration.git &&
    git -C project remote add report report:rebelplutonium/nixos-configuration.git &&
    git -C project committer.name "Emory Merryman" &&
    git -C project committer.email "emory.merryman@gmail.com" &&
    bash &&
    true
