#!/bin/sh

chromium --disable-gpu "${@}" &&
    true
