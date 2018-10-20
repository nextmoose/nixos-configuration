{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.pulseaudio.enable = true;
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  imports = [
    ./hardware-configuration.nix
    ./installed/password.nix
  ];
  networking = {
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "wl01";
    };
  };
  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "*/10 * * * * user nix-collect-garbage"
      ];
    };
    physlock.enable = true;
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      libinput.enable = true;
    };
  };
  sound.enable = true;
  time.timeZone = "US/Eastern";
  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
  };
  users.mutableUsers = false;
  users.extraUsers.user.isNormalUser = true;
  users.extraUsers.user.uid = 1000;
  users.extraUsers.user.extraGroups = [ "wheel" "docker" ];
  users.extraUsers.user.packages = [
    (import ./installed/init-read-only-pass/default.nix { inherit pkgs; })
    (import ./installed/init-wifi/default.nix { inherit pkgs; })
    (import ./custom/init-user-experience/default.nix { inherit pkgs; })
    (import ./custom/update-nixos/default.nix { inherit pkgs; })
    (import ./custom/bash/default.nix { inherit pkgs; })
    pkgs.pass
    pkgs.git
    pkgs.emacs
    pkgs.networkmanager
    pkgs.gnome3.gnome-terminal
    pkgs.chromium
  ];
  system.stateVersion = "18.03";
}
