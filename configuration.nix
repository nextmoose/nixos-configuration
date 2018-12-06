{ config, pkgs, ... }:
let
  initialization = (import ./custom/native/initialization/default.nix {});
  pass = (import ./custom/native/pass/default.nix {
    pkgs = pkgs;
  });
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
  systemd.services = {
    docker-container-system-secrets = (import ./custom/utils/docker-container.nix {
      image = "pass";
      name = "system-secrets";
      privileged = true;
      arguments = "github.com git 22 nextmoose secrets master";
    });
    docker-container-browser-secrets = (import ./custom/utils/docker-container.nix {
      image = "pass";
      name = "browser-secrets";
      arguments = "github.com git 22 nextmoose browser-secrets master";
    });
    docker-container-old-secrets = (import ./custom/utils/docker-container.nix {
      image = "pass";
      name = "old-secrets";
      arguments = "github.com git 22 desertedscorpion passwordstore master";
    });
    docker-image-pass = (import ./custom/utils/docker-image.nix {
      name = "pass";
      entrypoint = [ "${pass}/bin/pass" ];
    });
  };
  system.stateVersion = "18.03";
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
      (import ./custom/utils/pass/default.nix {
        pkgs = pkgs;
        name = "system-secrets";
        container-name = "system-secrets";
        script-name = "pass";
      })
      (import ./custom/utils/pass/default.nix {
        pkgs = pkgs;
        name = "old-secrets";
        container-name = "old-secrets";
        script-name = "pass";
      })
      (import ./custom/utils/pass/default.nix {
        pkgs = pkgs;
        name = "browser-secrets";
        container-name = "browser-secrets";
        script-name = "pass";
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
