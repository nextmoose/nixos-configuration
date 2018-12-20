#!/bin/sh

echo foo bar &&
    find /nix/store -name foobar &&
    true
