{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  container-initializations = (import ../expressions/container-initializations/default.nix { inherit pkgs; });
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
    programs.bash.shellInit = "${container-initialization}/bin/docker";
    environment.variables.DISPLAY=":0.0";
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
    };
  };
  tmpfs = [ "/home" ];
}
