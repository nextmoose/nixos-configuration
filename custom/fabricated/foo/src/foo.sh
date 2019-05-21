#!/bin/sh

export HOME=$(mktemp -d) &&
    init-gnupg &&
    pass init $(gnupg-key-id) &&
    pass git init &&
    pass git remote add origin https://github.com/nextmoose/secrets.git &&
    pass git fetch origin master &&
    bash &&
    true
