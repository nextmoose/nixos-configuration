{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  container-initializations = (import ../expressions/container-initializations/default.nix { inherit pkgs; });
in
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
      bash.shellInit = "${container-initializations}/bin/chromium";
      browserpass.enable = true;
      chromium = {
        enable = true;
	extensions = [
	  "naepdomgkenhinolocfifgehidddafch" # browserpass
	  "bkdgflcldnnnapblkhphbgpggdiikppg" # duck duck go
	];
      };
    };
    services = {
      cron = {
        enable = true;
	systemCronJobs = [
	  "* * * * *   user	git -C /home/user/.password-store fetch upstream master"
	  "* * * * *   user 	git -C /home/user/.password-store checkout upstream/master"
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
	(import ../expressions/chromium/default.nix { inherit pkgs; })
      ];
    };
  };
#  tmpfs = [ "/home" ];
}
