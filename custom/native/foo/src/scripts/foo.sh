#!/bin/sh

gnupg-import &&
  pass init $(gnupg-key-id) &&
  export ORIGIN_HOST=github.com &&
  export ORIGIN_USER=git &&
  export ORIGIN_PORT=22 &&
  dot-ssh &&
  pass git init &&
  pass git remote add origin origin:nextmoose/secrets.git &&
  pass git fetch origin master &&
  pass git checkout origin/master &&
  sleep-forever &&
  true
