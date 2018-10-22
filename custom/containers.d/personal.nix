{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  personal = (import ../expressions/personal/default.nix { inherit pkgs; });
in
{
  bindMounts = {
    "/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs" = {
      hostPath = "/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs";
      isReadOnly = true;
    };
    "/nix/var/nix/profiles/per-user/root/channels" = {
      hostPath = "/nix/var/nix/profiles/per-user/root/channels";
      isReadOnly = true;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0.0";
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
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      packages = [
#	personal
	nixos-container
        coreutils
	firefox
	emacs
	chromium
#	(import ../expressions/chromium/default.nix { inherit pkgs; })	
      ];
    };
  };
}
