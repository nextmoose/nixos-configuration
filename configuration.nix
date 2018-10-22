{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  containers = {
    archaic-secrets =
    let
      init-read-write-pass = (import ./custom/init-read-write-pass/default.nix { inherit pkgs; });
    in
    {
      config = { config, pkgs, ...}:
      {
        programs.bash.shellInit = ''
	  ${init-read-write-pass}/bin/init-read-write-pass \
	    --origin-host github.com \
	    --origin-port 22 \
	    --origin-user git \
	    --origin-organization desertedscorpion \
	    --origin-repository passwordstore \
	    --origin-branch master \
	    --committer-name "Emory Merryman" \
	    --committer-email emory.merryman@gmail.com \
	    &&
	    true
	'';
	services.mingetty.autologinUser = "user";
        users.extraUsers.user = {
	  isNormalUser = true;
	  packages = [
	    pkgs.browserpass
	    pkgs.pass
	    (import ./custom/chromium/default.nix { inherit pkgs; })
	  ];
	};
      };
      tmpfs = [ "/home" ];
    };
    chromium =
    let
      init-read-only-pass = (import ./installed/init-read-only-pass/default.nix { inherit pkgs; });
    in
    {
      autoStart = true;
      bindMounts = {
        "/run/user/1000" = {
	  hostPath = "/run/user/1000";
	  isReadOnly = true;
	};
        "/home/user/.config/pulse" = {
	  hostPath = "/home/user/.config/pulse";
	  isReadOnly = true;
	};
      };
      config = { config, pkgs, ...}:
      {
        environment.variables.DISPLAY=":0";
        hardware.pulseaudio.enable = true;
	programs = {
	  bash.shellInit = ''
	    ${init-read-only-pass}/bin/init-read-only-pass --upstream-url https://github.com/nextmoose/credentials.git --upstream-branch master &&
	      true
	  '';
	  browserpass.enable = true;
	  chromium = {
	    enable = true;
	    extensions = [ "naepdomgkenhinolocfifgehidddafch" ];
	  };
	};
	services.mingetty.autologinUser = "user";
        sound.enable = true;
	users.extraUsers.user = {
	  isNormalUser = true;
	  packages = [
	    pkgs.browserpass
	    pkgs.pass
	    (import ./custom/chromium/default.nix { inherit pkgs; })
	  ];
	};
      };
    };
    configuration =
    let
      init-development-environment = (import ./custom/init-development-environment/default.nix { inherit pkgs; });
    in
    {
      autoStart = true;
      config = { config, pkgs, ...}:
      {
        environment.variables.DISPLAY=":0";
        programs.bash.shellInit = ''
	  ${init-development-environment}/bin/init-development-environment \
	    --upstream-host github.com \
	    --upstream-user git \
	    --upstream-port 22 \
	    --upstream-organization rebelplutonium \
	    --upstream-repository nixos-configuration \
	    --upstream-branch master \
	    --origin-host github.com \
	    --origin-user git \
	    --origin-port 22 \
	    --origin-organization nextmoose \
	    --origin-repository nixos-configuration \
	    --origin-branch level-2 \
	    --report-host github.com \
	    --report-user git \
	    --report-port 22 \
	    --report-organization rebelplutonium \
	    --report-repository nixos-configuration \
	    --committer-name "Emory Merryman" \
	    --committer-email emory.merryman@gmail.com \
	    &&
	    true
	'';
	services.mingetty.autologinUser = "user";
	users.extraUsers.user = {
	  isNormalUser = true;
	  packages = [
	    pkgs.git
	    pkgs.emacs
	  ];
	};
      };
      tmpfs = [ "/home" ];
    };
    installation =
    let
      init-development-environment = (import ./custom/init-development-environment/default.nix { inherit pkgs; });
    in
    {
      autoStart = true;
      config = { config, pkgs, ...}:
      {
        environment.variables.DISPLAY=":0";
        programs.bash.shellInit = ''
	  ${init-development-environment}/bin/init-development-environment \
	    --upstream-host github.com \
	    --upstream-user git \
	    --upstream-port 22 \
	    --upstream-organization rebelplutonium \
	    --upstream-repository nixos-installer \
	    --upstream-branch master \
	    --origin-host github.com \
	    --origin-user git \
	    --origin-port 22 \
	    --origin-organization nextmoose \
	    --origin-repository nixos-installer \
	    --origin-branch level-2 \
	    --report-host github.com \
	    --report-user git \
	    --report-port 22 \
	    --report-organization rebelplutonium \
	    --report-repository nixos-installer \
	    --committer-name "Emory Merryman" \
	    --committer-email emory.merryman@gmail.com \
	    &&
	    true
	'';
	services.mingetty.autologinUser = "user";
	users.extraUsers.user = {
	  isNormalUser = true;
	  packages = [
	    pkgs.git
	    pkgs.emacs
	  ];
	};
      };
      tmpfs = [ "/home" ];
    };
    old-secrets =
    let
      initpass = (import ./installed/init-read-only-pass/default.nix { inherit pkgs; });
    in
    {
      autoStart = true;
      config = { config, pkgs, ...}:
      {
        programs.bash.shellInit = ''
	  ${initpass}/bin/init-read-only-pass --upstream-url https://github.com/desertedscorpion/passwordstore.git --upstream-branch master
	'';
        services.mingetty.autologinUser = "user";
        users.extraUsers.user = {
          isNormalUser = true;
	  packages = [
	    pkgs.pass
	  ];
        };
      };
    };
    experiment = {
      bindMounts = {
        "/tmp/.X11-unix" = {
	  hostPath = "/tmp/.X11-unix";
        };
        "/emory" = {
	  hostPath = "/";
	  isReadOnly = true;
	  mountPoint = "/host";
        };
      };
      config = { config, pkgs, ...}:
      {
        environment.variables.DISPLAY=":0";
        services.mingetty.autologinUser = "user";
        users.extraUsers.user = {
          isNormalUser = true;
	  packages = [
	    pkgs.chromium
	    pkgs.firefox
	    pkgs.emacs
	    pkgs.git
	  ];
        };
      };
    };
  };
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
  programs.bash.shellInit = ''
    ${pkgs.xorg.xhost}/bin/xhost +local:
    nixos-container start experiment
  '';
  security.sudo.wheelNeedsPassword = false;
  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "*/10 * * * * user nix-collect-garbage"
      ];
    };
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      libinput.enable = true;
    };
  };
  sound.enable = true;
  time.timeZone = "US/Eastern";
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
	flags = [ "--all" ];
	dates = "daily";
      };
    };
    virtualbox.host.enable = true;
  };
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
      (import ./custom/bash/default.nix { inherit pkgs; })
      (import ./custom/firefox/default.nix { inherit pkgs; })
      (import ./custom/personal/default.nix { inherit pkgs; })
      (import ./custom/restart-containers/default.nix { inherit pkgs; })
      pkgs.pass
      pkgs.git
      pkgs.emacs
      pkgs.networkmanager
      pkgs.gnome3.gnome-terminal
      pkgs.chromium
    ];
  };
  system.stateVersion = "18.03";
}
