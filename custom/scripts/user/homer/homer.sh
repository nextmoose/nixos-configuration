#!/bin/sh

nix-shell --pure --run homer /etc/nixos/custom/shells/homer.nix &&
    true
