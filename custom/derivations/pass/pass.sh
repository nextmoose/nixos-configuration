#!/bin/sh

shift 1 &&
  cat "${STORE_DIR}/var/${@}" &&
  true
