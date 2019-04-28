#!/bin/sh

UUID=b5b09d3c-88b5-47ed-b15a-ab9bd25fe37b &&
    if [ -z "$(docker container ls --quiet --filter uuid=${UUID})" ]
       WORK_DIR=$(mktemp -d) &&
	   cleanup(){
	       rm --recursive --force "${WORK_DIR}" &&
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
	       init-read-only-pass \
	       --remote https://github.com/nextmoose/secrets.git \
	       --branch master > "${WORK_DIR}/create.log" 2>&1 &&
	   docker \
	       container \
	       start \
	       --interactive \
	       --tty \
	       $(cat "${WORK_DIR}/cidfile") > "${WORK_DIR}/start.log" 2>&1 &&
	   true
    then
    fi &&
    docker \
	container \
	run \
	--interactive \
	--tty \
	--rm \
	--env GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt \
	--mount type=volume,source=$(docker container inspect --format '{{ range .Mounts }}{{ if eq .Destination "/home" }}{{ .Name }}{{ end }}{{ end }}' init-system-secrets-read-only-pass),target=/home,readonly=false \
	pass \
	"${@}" &&
    true
