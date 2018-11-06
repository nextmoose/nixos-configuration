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
    project \
	--upstream-organization goldroadrunner \
	--upstream-repository sadscissors \
      	--origin-organization nextmoose \
	--origin-repository sadscissors \
	--report-organization goldroadrunner \
	--report-repository sadscissors \
	--committer-name "Emory Merryman" \
	--committer-email "emory.merryman@gmail.com" \
	&&
    true
