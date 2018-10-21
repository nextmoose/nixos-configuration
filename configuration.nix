{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  containers = {
    chromium =
    {
      additionalCapabilities = [
##        "cap_audit_read"
##        "cap_block_suspend"
##        "cap_ipc_lock"
##        "cap_mac_admin"
##        "cap_mac_override"
##        "cap_net_admin"
##        "cap_syslog"
##        "cap_sys_module"
##        "cap_sys_pacct"
##        "cap_sys_rawio"
##        "cap_sys_time"
        "cap_wake_alarm"
      ];
      autoStart = true;
      bindMounts = {
        "/run/user/1000" = {
	  hostPath = "/run/user/1000";
	  isReadOnly = true;
	};
        "/etc/machine-id" = {
	  hostPath = "/etc/machine-id";
	  isReadOnly = true;
	};
#        "/var/run/dbus/system_bus_socket" = {
#	  hostPath = "/var/run/dbus/system_bus_socket";
#	  isReadOnly = true;
#	};
      };
      config = { config, pkgs, ...}:
      {
        environment.variables.DISPLAY=":0";
	services.mingetty.autologinUser = "user";
	users.extraUsers.user = {
	  isNormalUser = true;
	  packages = [
	    pkgs.git
	    pkgs.chromium
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
