{ pkgs }:
{
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
    environment.variables.DISPLAY=":0.0";
    hardware.pulseaudio.enable = true;
    programs = {
      browserpass.enable = true;
      chromium = {
        enable = true;
	extensions = [
	  "naepdomgkenhinolocfifgehidddafch" # browserpass
	  "bkdgflcldnnnapblkhphbgpggdiikppg" # duck duck go
	  "jlhmfgmfgeifomenelglieieghnjghma" # webex
	];
      };
    };
    services = {
      cron = {
        enable = true;
	systemCronJobs = [
	  "* * * * *   user	${pkgs.pass}/bin/pass git fetch upstream master && ${pass}/bin/pass git checkout upstream/master"
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
        pkgs.chromium
      ];
    };
  };
  tmpfs = [ "/home" ];
}
