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
  programs.bash.loginShellInit = ''
    ${staples.setup-user}/bin/setup-user \
      --canonical-system-remote https://github.com/nextmoose/secrets.git \
      --canonical-system-branch master \
      --committer-name "Emory Merryman" \
      --committer-email "emory.merryman@gmail.com" \
      --origin-challenge-remote origin:nextmoose/challenge-secrets.git \
      --origin-challenge-branch master \
      --origin-system-remote origin:nextmoose/secrets.git \
      --origin-system-branch master &&
      true
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
        "31 *  * * * user nix-collect-garbage"
      ];
    };
    dockerRegistry = {
      enable = true;
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
  system.stateVersion = "18.03";
  system.autoUpgrade = {
    enable = true;
  };
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
