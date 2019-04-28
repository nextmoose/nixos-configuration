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
  systemd.services = (import ./custom/systemd.nix {
    pkgs = pkgs;
    staples = staples;
  });
  time.timeZone = "US/Eastern";
  users = {
    mutableUsers = false;
    extraUsers.user.isNormalUser = true;
    extraUsers.user.uid = 1000;
    extraUsers.user.extraGroups = [ "wheel" "docker" ];
    extraUsers.user.packages = [
      pkgs.chromium
      pkgs.emacs
      pkgs.git
      pkgs.pass
      pkgs.python27Packages.xkcdpass
      staples.challenge-secrets
      staples.init-gnupg
      staples.init-read-only-pass
      staples.nmcli-wifi
      staples.install-nixos
      staples.read-write-pass
      staples.system-secrets-read-only-pass
      staples.system-secrets-read-write-pass
      (import ./custom/rescue/default.nix {
      	 pkgs = pkgs;
      })
    ];
  };
  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
  };
}
# lpadmin -p myprinter -E -v ipp://10.1.10.113/ipp/print -m everywhere
