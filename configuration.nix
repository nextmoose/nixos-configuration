{
  config,
  pkgs ? (import <nixpkgs>{}),
  ...
}:
let
  staples = (import ./custom/staples.nix {
    pkgs = pkgs;
  });
in
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  hardware = {
    pulseaudio.enable = true;
  };
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  imports = [
    ./hardware-configuration.nix
    ./custom/password.nix
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
        "31 *  * * * user nix-collect-garbage"
      ];
    };
    physlock = {
      allowAnyUser = true;
      disableSysRq = true;
      enable = true;
      lockOn = {
        extraTargets = [];
        hibernate = false;
        suspend = false;
      };
    };
    printing.enable = true;
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      libinput.enable = true;
    };
  };
  sound.enable = true;
  system = {
    autoUpgrade = {
      enable = true;
    };
    stateVersion = "18.03";
  };
  time.timeZone = "US/Eastern";
  users = {
    mutableUsers = false;
    extraUsers.user.isNormalUser = true;
    extraUsers.user.uid = 1000;
    extraUsers.user.extraGroups = [ "wheel" "docker" ];
    extraUsers.user.packages = [
      staples.add-ssh-domain
      staples.init-gnupg
      pkgs.chromium
      pkgs.emacs
      pkgs.git
      pkgs.pass
      staples.nmcli-wifi
      staples.install-nixos
      pkgs.jq
      pkgs.rkt
      pkgs.runc
      staples.init-dot-ssh
      pkgs.libxslt
      staples.browser-secrets-read-only-pass
      staples.old-secrets-read-only-pass
      pkgs.gnome3.gnome-terminal
    ];
  };
  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
  };
}
# lpadmin -p myprinter -E -v ipp://10.1.10.113/ipp/print -m everywhere
