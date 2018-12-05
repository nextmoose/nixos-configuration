#!/bin/sh

gnupg-import &&
  pass init $(gnupg-key-id) &&
  sleep-forever &&
  true
