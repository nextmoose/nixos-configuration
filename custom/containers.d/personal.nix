{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  personal = (import ../expressions/personal/default.nix { inherit pkgs; });
in
{
  config = { config, pkgs, ...}:
  {
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
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        coreutils
      ];
    };
  };
}
