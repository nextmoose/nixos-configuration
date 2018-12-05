#!/bin/sh

echo HELLO &&
  echo "${@}" &&
  seq 1 10 | while read
  do
    echo I=${I} &&
      true
  done &&
  cat "${@}" | docker image load &&
  echo "GOOD BYE" &&
  true
