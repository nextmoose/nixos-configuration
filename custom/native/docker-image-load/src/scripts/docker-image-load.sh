#!/bin/sh

echo "${@}" &&
  cat "${@}" | docker image load &&
  true
