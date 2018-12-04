#!/bin/sh

CID=$(docker container create "${@}") &&
  docker container start --interactive "${CID}" &&
  true
