#!/bin/sh

CID=$(docker container create "${@}") &&
  docker container --interactive start "${CID}" &&
  true
