#!/bin/sh

pvcreate /dev/sda4 &&
    vgcreate volumes /dev/sda4 &&
    lvcreate --name gnucash --size 1G volumes &&
    mkfs.ext4 /dev/volumes/gnucash &&
    DIR=$(mktemp -d) &&
    mount /dev/volumes/gnucash ${DIR} &&
    mkdir ${DIR}/user &&
    chown 1000:100 ${DIR}/user &&
    if [ -d /root/mnt/configuration/custom ]
    then
	ls -1 /root/mnt/configuration/custom | grep "[.]d\$" | while read DOMAIN
	do
	    (cat > /root/mnt/configuration/custom/${DOMAIN%.*}.nix <<EOF
{ pkgs ? impor	 t <nixpkgs> {} }:
with import <nixp  kgs> {};
{    
EOF
	    ) &&
		ls -1 /root/mnt/configuration/custom/${DOMAIN} | grep "[.]nix\$" | while read SUB
		do
		    echo "  ${SUB%.*} = (import ./${DOMAIN%.*}.d/${SUB%.*}.nix { inherit pkgs; });" >> /root/mnt/configuration/custom/${DOMAIN%.*}.nix
		    true
		done &&
		(cat >> /root/mnt/configuration/custom/${DOMAIN%.*}.nix && <<EOF
}
EOF
		) &&
		true
	done &&
	    true
    fi &&
    true
