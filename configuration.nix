{ config, pkgs, ... }:
let
  docker-container-start = (import ./custom/native/docker-container-start { pkgs=pkgs;});
  docker-image-load = (import ./custom/native/docker-image-load { pkgs=pkgs;});
  initialization = (import ./custom/native/initialization/default.nix {});
  foo = (import ./custom/native/foo/default.nix {});
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
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
  programs.bash.shellInit = "${pkgs.xorg.xhost}/bin/xhost +local:";
  security.sudo.wheelNeedsPassword = false;
  services = {
    apache-kafka = {
      brokerId = 15272;
      enable = true;

    };
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
  system.stateVersion = "18.03";
  systemd.services.docker-image-foo = (import ./custom/utils/docker-image-load.nix{
    pkgs = ${pkgs};
    name = "foo";
    image = (import ./custom/native/docker-image-load/docker/foo.nix {
      pkgs = ${pkgs};
    });
  });
  systemd.services.docker-image-load = {
    description = "Docker Image Pull";
    enable = true;
    serviceConfig = {
      Type = "forking";
      ExecStart = "${docker-image-load}/bin/docker-image-load";
    };
    wantedBy = [ "default.target" ];
  };
  systemd.services.foo = {
    description = "FOO Daemon";
    enable = true;
    serviceConfig = {
      Type = "forking";
      ExecStart = "${initialization}/bin/initialization";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };
  time.timeZone = "US/Eastern";
  users = {
    mutableUsers = false;
    extraUsers.user.isNormalUser = true;
    extraUsers.user.uid = 1000;
    extraUsers.user.extraGroups = [ "wheel" "docker" ];
    extraUsers.user.packages = [
      (import ./installed/default.nix { inherit pkgs; })
      (import ./custom/native/utils/default.nix {})
      (import ./custom/native/create-installation-media/default.nix {})
      (import ./custom/native/validate-not-blank/default.nix {})
      (import ./custom/system/update-nixos/default.nix { inherit pkgs; })
      (import ./custom/user/atom/default.nix {})
      (import ./custom/user/alpha-pass/default.nix {})
      (import ./custom/user/browser-secrets/default.nix {})
      (import ./custom/user/old-secrets/default.nix {})
      (import ./custom/utils/pass.old/default.nix {
        name = "foo";
        uuid = "uuid";
        origin-repository = "browser-secrets";
      })
      initialization
      pkgs.emacs
      pkgs.networkmanager
      pkgs.gnome3.gnome-terminal
      pkgs.recordmydesktop
      pkgs.git
      pkgs.zip
      pkgs.unzip
      pkgs.chromium
      pkgs.physlock
      pkgs.nixops
    ];
  };
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
      dates = "daily";
    };
  };
}
# lpadmin -p myprinter -E -v ipp://10.1.10.113/ipp/print -m everywhere
