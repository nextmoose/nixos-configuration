#!/bin/sh

export HOME=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${HOME}" &&
	    true
    } &&
    trap cleanup EXIT &&
    cd "${HOME}" &&
    init-gnupg &&
    pass init "$(gnupg-key-id)" &&
    pass git init &&
    pass git remote add canonical "${1}" &&
    pass git fetch canonical "${2}" &&
    pass git checkout "canonical/${2}" &&
    true
