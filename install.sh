#!/bin/sh

pvcreate /dev/sda4 &&
    vgcreate volumes /dev/sda4 &&
    lvcreate --name gnucash --size 1G volumes &&
    mkfs.ext4 /dev/volumes/gnucash &&
    DIR=$(mktemp -d) &&
    mount /dev/volumes/gnucash ${DIR} &&
    mkdir ${DIR}/user &&
    chown 1000:100 ${DIR}/user &&
    (cat > /mnt/etc/nixos/custom/containers.nix <<EOF
{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
{
}
EOF
    ) &&
    cp /mnt/etc/nixos/custom/containers.nix /mnt/etc/nixos/custom/virtualisation.nix &&
    true
