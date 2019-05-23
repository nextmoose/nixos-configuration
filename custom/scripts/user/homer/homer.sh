#!/bin/sh

if [ "${#}" -eq 0 ]
then
    nix-shell --pure /etc/nixos/custom/shells/homer.nix &&
	true
else
    nix-shell --argstring name "${@}" --pure /etc/nixos/custom/shells/homer.nix &&
	true
fi &&
    true
