#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --mount type=volume,source=$(docker container inspect --format '{{ range .Mounts }}{{ if eq .Destination "/home" }}{{ .Name }}{{ end }}{{ end }}' $(docker container ls --quiet init-system-secrets-read-only-pass)),target=/home,readonly=false \
    pass \
    "${@}" &&
    true
