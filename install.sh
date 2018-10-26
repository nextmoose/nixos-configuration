#!/bin/sh

pvcreate /dev/sda4 &&
    vgcreate volumes /dev/sda4 &&
    lvcreate --name gnucash --size 1G volumes &&
    mkfs.ext4 /dev/volumes/gnucash &&
    DIR=$(mktemp -d) &&
    mount /dev/volumes/gnucash ${DIR} &&
    mkdir ${DIR}/user &&
    chown 1000:100 ${DIR}/user &&
    create-nixos-objects --root /mnt/etc/nixos/custom &&
    true
