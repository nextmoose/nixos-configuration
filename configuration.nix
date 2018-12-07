{ config, pkgs, ... }:
let
  installed-pass = (import ./installed/pass/default.nix{
    pkgs = pkgs;
  });
  initialization = (import ./custom/native/initialization/default.nix {});
  pass = (import ./custom/native/pass/default.nix {
    pkgs = pkgs;
  });
  lighttable = (import ./custom/initialization/lighttable/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  containers = {
    chromium = (import ./custom/containers/chromium.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
    gnucash = (import ./custom/containers/gnucash.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
  old-secrets = (import ./custom/containers/old-secrets.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
    browser-secrets = (import ./custom/containers/browser-secrets.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
    system-secrets = (import ./custom/containers/system-secrets.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
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
  systemd.services.docker-image-lighttable = (import ./custom/utils/docker-image.nix {
    name = "lighttable";
    entrypoint = [ "${lighttable}/bin/lighttable" ];
  });
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
      (import ./installed/pass/default.nix {})
      (import ./installed/default.nix { inherit pkgs; })
      (import ./custom/native/utils/default.nix {})
      (import ./custom/native/create-installation-media/default.nix {})
      (import ./custom/native/validate-not-blank/default.nix {})
      (import ./custom/system/update-nixos/default.nix { inherit pkgs; })
      (import ./custom/user/atom/default.nix {})
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
      (import ./custom/native/node/default.nix {
        pkgs = pkgs;
      })
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
