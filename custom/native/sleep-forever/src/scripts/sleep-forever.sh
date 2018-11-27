#!/bin/sh

set-healthy &&
    tail --follow /dev/null &&
    true
