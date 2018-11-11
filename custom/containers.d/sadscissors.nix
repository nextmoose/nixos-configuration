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
      bash.shellInit = "${container-initializations}/bin/sadscissors.nix";
      chromium = {
        enable = true;
	extensions = [
	  "bkdgflcldnnnapblkhphbgpggdiikppg" # duck duck go
	];
      };
    };
    services.mingetty.autologinUser = "user";
    sound.enable = true;
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        emacs
	gradle
	git
      ];
    };
  };
  tmpfs = [ "/home" ];
}
