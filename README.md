# nixos-configuration

## About
This is my custom nixos configuration.
It is designed to work with https://github.com/rebelplutonium/nixos-installation.git.

## Use Password
The following code in 'configuration.nix' will set the user password
```
  imports = [
    ./hardware-configuration.nix
    ./installed/password.nix
  ];
```
The './hardware-configuration.nix' file should be installed by 'nixos-generate'.
The './installed/password.nix' file should be installed by the 'installer' script and it will set the user password.  By referencing it in this way, 'configuration.nix' can (1) completely configure the system - including setting the user password; and (2) be published publicly without compromising confidential data

## Volumes GROUP
The installer script does not allocate very much (64G) to the ROOT partition.  However, this should be more than enough for needs because the remaining disk space is allocated to the volumes LVM Volume Group.
We can use this space in this way:
1. Create a logical volume in the 'install.sh' script.
2. Mount the local volume in the 'configuration.nix' file
```
  fileSystems."/srv/gnucash" = {
    device = "/dev/volumes/gnucash";
    fsType = "ext4";
  };
```
These volumes can be encrypted but will not be encrypted by default.
Logical volumes can be snapshotted (useful for backup).

Without encryption, these volumes should be marginally faster than the encrypted root.
This might be useful for working on non-sensitive development code.

# What is Installed
## Containers
   I believe in containers.
   Every directory in custom/containers.d describes a container that will be created.
   Each container has its own user space and installed programs.
   Many of the containers can run GUI programs.
   In fact, I browse the web through a nixos-container.
## Expressions
   I have a collection of custom nixos expressions in custom/expressions.
## Host
   The host automagically runs `${pkgs.xorg.xhost}/bin/xhost +local:` which enables the containers to run GUI apps.
   
   The host collects and disposes of garbage every hour.  This helps the system stay within its 64G ROOT allocation.

   The host has a few programs installed.  My goal is to move all (or most) of these useful programs into containers.