#!/bin/sh

secrets \
    --canonical-host github.com \
    --canonical-organization nextmoose \
    --canonical-repository secrets \
    --canonical-branch master \
    &&
    ssh-remote \
	--remote upstream \
	--host github.com \
	--user git \
	--port 22 \
	&&
    ssh-remote \
	--remote origin \
	--host github.com \
	--user git \
	--port 22 \
	&&
    ssh-remote \
	--remote report \
	--host github.com \
	--user git \
	--port 22 \
	&&
    read-write-pass \
	--upstream-organization nextmoose \
	--upstream-repository browser-secrets \
      	--origin-organization nextmoose \
	--origin-repository browser-secrets \
	--report-organization rebelplutonium \
	--report-repository browser-secrets \
	--writability readwrite \
	&&
    true
