#!/bin/sh

export HOME="$(mktemp -d)" &&
    cleanup(){
	rm --recursive --force "${HOME}" &&
	    true
    } &&
    trap cleanup EXIT &&
    echo ${1} &&
    bash &&
    true
