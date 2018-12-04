#!/bin/sh

CID=$(docker container create "${@}") &&
  echo DO IT ... docker container start --interactive "${CID}" &&
  docker container start --interactive "${CID}" &&
  true
