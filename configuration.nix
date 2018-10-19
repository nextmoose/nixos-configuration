{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./installed/password.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  users.mutableUsers = false;
  users.extraUsers.user.isNormalUser = true;
  users.extraUsers.user.uid = 1000;
  users.extraUsers.user.extraGroups = [ "wheel" ];
  users.extraUsers.user.packages = [
    (import ./installed/secrets/default.nix { inherit pkgs; })
    (import ./custom/secrets/default.nix { inherit pkgs; })
  ];
  system.stateVersion = "18.03";
}
