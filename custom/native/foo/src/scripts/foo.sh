#!/bin/sh

gnupg-import &&
  pass init $(gnupg-key-id) &&
  dot-ssh &&s
  sleep-forever &&
  true
