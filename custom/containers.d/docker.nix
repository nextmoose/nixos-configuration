{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  container-initializations = (import ../expressions/container-initializations/default.nix { inherit pkgs; });
  development = (import ../expressions/development/default.nix { inherit pkgs; });
in
{
  bindMounts = {
    "/var/run/docker.sock" = {
      hostPath = "/var/run/docker.sock";
      isReadOnly = true;
    };
  };
  config = { config, pkgs, ...}:
  {
#    programs.bash.shellInit = "${container-initializations}/bin/docker";
    environment.variables.DISPLAY=":0.0";
    security.sudo.wheelNeedsPassword = false;
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      extraGroups = [ "docker" "wheel" ];
      packages = [
        bash
	coreutils
        docker
        pass
        development
	container-initializations
      ];
    };
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
        dates = "daily";
      };
    };
  };
  tmpfs = [ "/home" ];
}
