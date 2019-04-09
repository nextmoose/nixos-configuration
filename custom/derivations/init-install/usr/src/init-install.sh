#!/bin/sh

(cat <<EOF
n


+200M
EF00
n


+8G
8200
n


+264G

n



8E00
w
Y
EOF
) | gdisk /dev/sda &&
  mkfs.vfat -F 32 -n BOOT /dev/sda1 &&
  mkswap -L SWAP /dev/sda2 &&
  echo -n "${LUKS_PASSPHRASE}" | cryptsetup --key-file - luksFormat /dev/sda3 &&
  echo -n "${LUKS_PASSPHRASE}" | cryptsetup --key-file - luksOpen /dev/sda3 root &&
  echo y | mkfs.ext4 -L ROOT /dev/mapper/root &&
  mount /dev/mapper/root /mnt &&
  mkdir /mnt/boot &&
  mount /dev/sda1 /mnt/boot/ &&
  swapon -L SWAP &&
  mkdir /mnt/etc &&
  mkdir /mnt/etc/nixos &&
  cp "${STORE_DIR}/etc/nixos/configuration.nix" /mnt/etc/nixos/configuration.nix &&
  cp --recursive "${STORE_DIR}/etc/nixos/custom" /mnt/etc/nixos &&
  sed \
    -e "s#\${HASHED_USER_PASSWORD}#${HASHED_USER_PASSWORD}" \
    -e "w/mnt/etc/nixos/common/password.nix" \
    "${STORE_DIR}/etc/nixos/common/password.nix" &&
  PATH=/run/current-system/sw/bin nixos-generate-config --root /mnt &&
  PATH=/run/current-system/sw/bin nixos-install --root /mnt --no-root-passwd &&
  true
