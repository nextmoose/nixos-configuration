#!/bin/sh

gpg --output /tmp/secrets.tar.gz --decrypt "${STORE_DIR}/etc/seed-secrets/secrets.tar.gz.gpg" &&
  gunzip /tmp/secrets.tar.gz > /tmp/secrets.tar &&
  tar --extract --file /tmp/secrets.tar --directory /tmp &&
  true
