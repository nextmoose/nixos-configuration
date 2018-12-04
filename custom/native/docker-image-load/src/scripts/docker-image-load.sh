#!/bin/sh

cat "${@}" | docker image load &&
  true
