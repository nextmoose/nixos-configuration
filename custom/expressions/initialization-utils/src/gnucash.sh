#!/bin/sh

OLD_HOME=${HOME} &&
    HOME=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${HOME} &&
	    true
    } &&
    trap cleanup EXIT &&
    init-read-only-pass --upstream-url https://github.com/nextmoose/aws-secrets.git --upstream-branch master &&
    export AWS_ACCESS_KEY_ID=... &&
    export AWS_SECRET_ACCESS_KEY=$(pass show gnucash) &&
    export AWS_DEFAULT_REGION=us-east-1 &&
    
    true
