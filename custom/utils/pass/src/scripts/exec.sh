#!/bin/sh

docker \
  container \
  exec \
  --interactive \
  --tty \
  "${CONTAINER_NAME}" \
  "${SCRIPT_NAME}" \
  "${@}" &&
  true
