{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
{
  bindMounts = {
    "/var/run/docker.sock" = {
      hostPath = "/var/run/docker.sock";
      isReadOnly = true;
    };
  };
  config = { config, pkgs, ...}:
  {
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        docker
      ];
    };
  };
  tmpfs = [ "/home" ];
}
