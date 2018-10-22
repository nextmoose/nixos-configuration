{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  personal = (import ../expressions/personal/default.nix { inherit pkgs; });
in
{
  bindMounts = {
    "/home/user/.config/pulse" = {
      hostPath = "/home/user/.config/pulse";
      isReadOnly = true;
    };
    "/var/run/docker.sock" = {
      hostPath = "/var/run/docker.sock";
      isReadOnly = true;
    };
    "/run/user/1000" = {
      hostPath = "/run/user/1000";
      isReadOnly = true;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0";
    hardware.pulseaudio.enable = true;
    programs = {
      bash.shellInit = ''
        ${personal}/bin/shell-init &&
	  true
      '';
      bash.loginShellInit = ''
        ${personal}/bin/login-shell-init &&
	  true
      '';
    };
    security.sudo.wheelNeedsPassword = false;
    services.mingetty.autologinUser = "user";
    sound.enable = true;
    users.extraUsers.user = {
      extraGroups = [ "wheel" "docker" ];
      isNormalUser = true;
      packages = [
        coreutils
	personal
	docker
	(import ../expressions/chromium/default.nix { inherit pkgs; })	
      ];
    };
  };
  tmpfs = [ "/home" ];
}
