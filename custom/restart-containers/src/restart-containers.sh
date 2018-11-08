#!/bin/sh

/run/wrappers/bin/sudo nixos-container list | while read CONTAINER
do
    (/run/wrappers/bin/sudo nixos-container stop "${CONTAINER}" || true) &&
	/run/wrappers/bin/sudo nixos-container start "${CONTAINER}" &&
	true
done &&
    true
