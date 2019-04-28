#!/bin/sh

UUID=ba7743e2-61d9-4c3b-8595-fb82059756ad &&
    if [ -z "$(docker container ls --quiet --all --filter label=uuid=${UUID})" ]
    then
	WORK_DIR=$(mktemp -d) &&
	    cleanup(){
		echo rm --recursive --force "${WORK_DIR}" &&
		    true
	    } &&
	    trap cleanup EXIT &&
	    docker \
		container \
		create \
		--cidfile "${WORK_DIR}/cid" \
		--interactive \
		--tty \
		--label uuid=${UUID} \
		init-read-write-pass \
		--host github.com \
		--id-rsa "$(system-secrets-read-only-pass show origin.id_rsa)" \
		--user-known-hosts "$(system-secrets-read-only-pass show origin.known_hosts)" \
		--user git \
		--remote origin:nextmoose/secrets.git \
		--branch master > "${WORK_DIR}/create.log" 2>&1 &&
	    docker \
		container \
		start \
		--interactive \
		$(cat "${WORK_DIR}/cid") > "${WORK_DIR}/start.log" 2>&1 &&
	    true
    fi &&
    docker \
	container \
	run \
	--interactive \
	--tty \
	--rm \
	--env GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt \
	--mount type=volume,source=$(docker container inspect --format '{{ range .Mounts }}{{ if eq .Destination "/home" }}{{ .Name }}{{ end }}{{ end }}' $(docker container ls --quiet --all --filter label=uuid=${UUID})),target=/home,readonly=false \
	pass \
	"${@}" &&
    true
