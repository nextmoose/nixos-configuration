#!/bin/sh

gnupg-import &&
  pass init $(gnupg-key-id) &&
  export ORIGIN_HOST="${1}" &&
  export ORIGIN_USER="${2}" &&
  export ORIGIN_PORT="${3}" &&
  dot-ssh  &&
  pass git init &&
  pass git remote add origin origin:"${4}"/"${5}".git &&
  pass git fetch origin "${6}" &&
  pass git checkout "origin/${6}" &&
  sleep-forever &&
  true
