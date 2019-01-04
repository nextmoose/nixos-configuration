{
  pkgs ? import <nixpkgs> {},
  pass
}:
let
  initialization = (import ../initialization/chromium/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
  flash = (import ../native/flash/default.nix {
    pkgs = pkgs;
  });
  chromium = (import ../native/chromium/default.nix {
    pkgs = pkgs;
    flash = flash;
  });
in
{
  additionalCapabilities = [
    "CAP_SYS_ADMIN"
  ];
  allowedDevices = [ {
    modifier = "rw";
    node = "/dev/video0";
  }];
  bindMounts = {
    "/run/user/1000" = {
      hostPath = "/run/user/1000";
      isReadOnly = true;
    };
    "/home/user/.config/pulse" = {
      hostPath = "/home/user/.config/pulse";
      isReadOnly = true;
    };
    "/srv/host" = {
      hostPath = "/";
      isReadOnly = true;
    };
    "/srv/home" = {
      hostPath = "/home/user";
      isReadOnly = false;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0.0";
    hardware.pulseaudio.enable = true;
    programs = {
      bash.shellInit = ''
        ${initialization}/bin/chromium \
          --upstream-host github.com \
          --upstream-user git \
          --upstream-port 22 \
          --upstream-organization nextmoose \
          --upstream-repository browser-secrets \
          --upstream-branch master
      '';
      browserpass.enable = true;
      chromium = {
        enable = true;
	extensions = [
	  "naepdomgkenhinolocfifgehidddafch" # browserpass
	  "bkdgflcldnnnapblkhphbgpggdiikppg" # duck duck go
	  "jlhmfgmfgeifomenelglieieghnjghma" # webex
	  "hmbjbjdpkobdjplfobhljndfdfdipjhg" # zoom
	];
      };
    };
    services = {
      cron = {
        enable = true;
	systemCronJobs = [
	  "* * * * *   user	${pkgs.pass}/bin/pass git fetch upstream master && ${pkgs.pass}/bin/pass git checkout upstream/master"
	];
      };
      mingetty.autologinUser = "user";
    };
    sound.enable = true;
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        pkgs.browserpass
	      pkgs.pass
        chromium
      ];
    };
  };
  tmpfs = [ "/home" ];
}
