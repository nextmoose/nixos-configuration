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
    (import ./installed/init-read-only-pass/default.nix { inherit pkgs; })
    (import ./installed/init-wifi/default.nix { inherit pkgs; })
    (import ./custom/init-user-experience/default.nix { inherit pkgs; })
    (import ./custom/update-nixos/default.nix { inherit pkgs; })
    pkgs.pass
    pkgs.git
    pkgs.emacs
    pkgs.networkmanager
  ];
  system.stateVersion = "18.03";
}
