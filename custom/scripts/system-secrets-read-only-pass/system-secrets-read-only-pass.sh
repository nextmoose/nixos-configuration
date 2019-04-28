#!/bin/sh

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
