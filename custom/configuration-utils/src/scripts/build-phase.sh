#!/bin/sh

mkdir build &&
    if [ -d scripts ]
    then
	cp --recursive scripts build &&
	    chmod --recursive 0500 build/scripts/. &&
	    true
    fi &&
    if [ -d lib ]
    then
	cp --recursive lib build &&
	    chmod --recursive 0400 build/lib/. &&
	    true
    fi &&
    if [ -f wrappers.sh ]
    then
	makeWrapper wrappers.sh build/wrappers.sh &&
	    true
    fi &&
    true
    
