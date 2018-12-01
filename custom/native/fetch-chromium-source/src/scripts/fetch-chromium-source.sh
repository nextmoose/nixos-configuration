#!/bin/#!/bin/sh

mkdir $(mktemp -d) &&
  fetch --nohooks --no-history chromium &&
  echo src &&
  true
