#!/bin/sh

cat "${STORE_DIR}/etc/secrets/${@}" &&
  true
