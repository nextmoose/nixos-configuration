#!/bin/sh

secrets \
    --canonical-host github.com \
    --canonical-organization nextmoose \
    --canonical-repository secrets \
    --canonical-branch master &&
    read-only-pass \
	--upstream-organization nextmoose \
	--upstream-repository aws-secrets \
	--upstream-branch master &&
    true
