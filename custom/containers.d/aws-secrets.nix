{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  container-initializations = (import ../expressions/container-initializations/default.nix { inherit pkgs; });
in
{
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0";
    programs.bash.shellInit = "${container-initializations}/bin/aws-secrets";
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
	pkgs.git
	pkgs.emacs
	pkgs.pass
	(import ../expressions/pass-utils/default.nix { inherit pkgs; })
      ];
    };
  };
  tmpfs = [ "/home" ];
}
