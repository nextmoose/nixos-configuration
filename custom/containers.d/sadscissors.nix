{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  container-initializations = (import ../expressions/container-initializations/default.nix { inherit pkgs; });
in
{
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0";
    programs.bash.shellInit = "${container-initializations}/bin/sadscissors";
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
	pkgs.git
	pkgs.emacs
	pkgs.gradle
	pkgs.netbeans
	pkgs.geany
	pkgs.jedit
	pkgs.jdk10
	pkgs.checkstyle
	pkgs.chromium
      ];
    };
  };
  tmpfs = [ "/home" ];
}
