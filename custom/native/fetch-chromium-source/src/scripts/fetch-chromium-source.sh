#!/bin/#!/bin/sh

mkdir src &&
  cd src &&
  fetch --nohooks --no-history chromium &&
  echo src &&
  true
