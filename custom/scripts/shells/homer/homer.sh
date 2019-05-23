#!/bin/sh

export HOME="$(mktemp -d)" &&
    cleanup(){
	rm --recursive --force "${HOME}" &&
	    echo Good Bye | cowsay &&
	    true
    } &&
    trap cleanup EXIT &&
    echo hello | cowsay &&
    bash &&
    true
