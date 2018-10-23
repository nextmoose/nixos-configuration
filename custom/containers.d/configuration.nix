{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  container-intializations = (import ../expressions/container-initializations/default.nix { inherit pkgs; });
in
{
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0";
    programs.bash.shellInit = "${container-initializations}/bin/configuration";
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
}
