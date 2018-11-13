#!/bin/sh

git rev-parse HEAD &&
    if ! git diff --exit-code
    then
        echo There are local unstaged changes. &&
            exit 67 &&
	    true
    elif ! git diff --cached --exit-code
    then
        echo There are local changes that are staged but not committed. &&
            exit 67 &&
	    true
    elif [ ! -z "$(git ls-files --other --exclude-standard --directory --exclude .c9)" ]
    then
        echo There are untracked files that are not .gitignored - nor are they part of .c9. &&
            exit 67 &&
	    true
    else
        echo The project is clean. &&
            exit 0 &&
	    true
    fi &&
    true
