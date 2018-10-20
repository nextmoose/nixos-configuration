{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  containers = {
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
