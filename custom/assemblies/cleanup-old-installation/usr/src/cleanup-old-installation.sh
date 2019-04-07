#!/bin/sh

(swapoff -L SWAP || true ) &&
  (umount /mnt/nix || true) &&
  (umount /mnt/boot || true) &&
  (umount /mnt || true) &&
  (cryptsetup luksClose /dev/mapper/root || true) &&
  lvs --options NAME volumes | tail -n -1 | while read NAME
  do
    wipefs --all /dev/volumes/${NAME} &&
      (lvremove --force /dev/volumes/${NAME} || true) &&
      true
  done &&
  (vgremove --force /dev/volumes || true) &&
  (pvremove --force /dev/volumes || true) &&
  echo p | gdisk /dev/sda | grep "^\s*[0-9]" | sed -e "s#^\s*##" -e "s#\s.*\$##" | while read I
  do
    wipefs --all /dev/sda${I} &&
    (cat <<EOF
d
${I}
w
y
EOF
    ) | gdisk /dev/sda &&
    true
