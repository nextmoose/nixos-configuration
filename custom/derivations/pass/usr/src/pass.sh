#!/bin/sh

shift 1 &&
  cat "${STORE_DIR}/etc/pass/${@}" &&
  true
