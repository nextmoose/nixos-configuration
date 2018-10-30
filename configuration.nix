{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  containers = (import ./custom/containers.nix { inherit pkgs; });
  hardware = {
    pulseaudio.enable = true;
    sane = {
      enable = true;
      netConf = "10.1.10.113";
    };
  };
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  imports = [
    ./hardware-configuration.nix
    ./installed/password.nix
  ];
  fileSystems."/srv/gnucash" = {
    device = "/dev/volumes/gnucash";
    fsType = "ext4";
  };
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
  programs.bash.shellInit = ''
    ${pkgs.xorg.xhost}/bin/xhost +local:
  '';
  security.sudo.wheelNeedsPassword = false;
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
	userServices = true;
      };
    };
    cron = {
      enable = true;
      systemCronJobs = [
        "*/10 *  * * * user nix-collect-garbage"
      ];
    };
    printing.enable = true;
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      libinput.enable = true;
    };
  };
  sound.enable = true;
  time.timeZone = "US/Eastern";
  virtualisation = (import ./custom/virtualisation.nix { inherit pkgs; });
  users = {
    mutableUsers = false;
    extraUsers.user.isNormalUser = true;
    extraUsers.user.uid = 1000;
    extraUsers.user.extraGroups = [ "wheel" "docker" ];
    extraUsers.user.packages = [
      (import ./installed/init-read-only-pass/default.nix { inherit pkgs; })
      (import ./installed/init-wifi/default.nix { inherit pkgs; })
      (import ./custom/init-user-experience/default.nix { inherit pkgs; })
      (import ./custom/update-nixos/default.nix { inherit pkgs; })
      (import ./custom/personal/default.nix { inherit pkgs; })
      (import ./custom/restart-containers/default.nix { inherit pkgs; })
      pkgs.pass
      pkgs.git
      pkgs.emacs
      pkgs.networkmanager
      pkgs.gnome3.gnome-terminal
      pkgs.chromium
      pkgs.firefox
      pkgs.gnupg
      pkgs.awscli
      pkgs.sane-backends
      pkgs.saneBackends
      pkgs.sane-backends-git
      pkgs.saneBackendsGit
      pkgs.saneFrontends
      pkgs.sane-frontends
      pkgs.swingsane
      pkgs.unpaper
      pkgs.xsane
      pkgs.filezilla
      (import ./custom/expressions/builder/default.nix { inherit pkgs; })
      (import ./custom/expressions/backup-utils/default.nix { inherit pkgs; })
      (import ./custom/expressions/docker/default.nix { inherit pkgs; })
    ];
  };
  system.stateVersion = "18.03";
}
# lpadmin -p myprinter -E -v ipp://10.1.10.113/ipp/print -m everywhere