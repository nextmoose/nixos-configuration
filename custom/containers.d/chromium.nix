{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  init-read-only-pass = (import ../../installed/init-read-only-pass/default.nix { inherit pkgs; });
in
{
  autoStart = false;
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
	(import ../expressions/chromium/default.nix { inherit pkgs; })
      ];
    };
  };
}
