#!/bin/sh

init-dot-ssh &&
    init-dot-ssh-host \
	--host upstream \
	--host-name github.com \
	--user git \
	--id-rsa "$(system-secrets-read-only-pass show upstream.id_rsa)" \
	--known-hosts "$(system-secrets-read-only-pass show upstream.known_hosts)" &&
    init-dot-ssh-host \
	--host origin \
	--host-name github.com \
	--user git \
	--id-rsa "$(system-secrets-read-only-pass show origin.id_rsa)" \
	--known-hosts "$(system-secrets-read-only-pass show origin.known_hosts)" &&
    init-dot-ssh-host \
	--host report \
	--host-name github.com \
	--user git \
	--id-rsa "$(system-secrets-read-only-pass show report.id_rsa)" \
	--known-hosts "$(system-secrets-read-only-pass show report.known_hosts)" &&
    mkdir project &&
    git -C project init &&
    git -C project remote add upstream upstream:rebelplutonium/nixos-configuration.git &&
    git -C project remote add origin origin:nextmoose/nixos-configuration.git &&
    git -C project remote add report report:rebelplutonium/nixos-configuration.git &&
    git -C project committer.name "Emory Merryman" &&
    git -C project committer.email "emory.merryman@gmail.com" &&
    bash &&
    true
