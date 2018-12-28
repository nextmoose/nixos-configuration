#!/bin/sh

echo curl --insecure "${@}" &&
    curl --insecure "${@}" &&
    true
