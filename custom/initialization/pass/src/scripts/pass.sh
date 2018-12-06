#!/bin/sh

gnupg &&
  dot-ssh "${@}" &&
  pass init $(gpg-key-id) &&
#  pass git remote add origin origin &&
#  pass git fetch origin
#  pass git checkout
#  true
