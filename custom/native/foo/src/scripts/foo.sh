#!/bin/sh

gnupg-import &&
  pass init $(gnupg-key-id) &&
  echo hello world &&
  sleep-forever &&
  true
