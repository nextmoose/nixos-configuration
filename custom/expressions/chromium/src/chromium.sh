#!/bin/sh

chromium --disable-gpu --user-data-dir=/home/user "${@}" &&
    true
