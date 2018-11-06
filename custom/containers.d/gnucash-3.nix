{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  container-initializations = (import ../expressions/container-initializations/default.nix { inherit pkgs; });
in
{
  config = { config, pkgs, ...}:
  {
    environment.variables = {
      BUCKET="e613b6bb-3d0b-4d02-8af9-6b05a3c89d3e";
      DISPLAY=":0";
    };
    services.mingetty.autologinUser = "user";
    programs.bash.shellInit = "${container-initializations}/bin/gnucash-3";
    users.extraUsers.user = {
      isNormalUser = true;
    };
    packages = [
      gnucash
    ];
  };
  tmpfs = [ "/home" ];
}
