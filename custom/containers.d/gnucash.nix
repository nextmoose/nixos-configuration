{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  backup-utils = (import ../expressions/backup-utils/default.nix { inherit pkgs; });
in
{
  bindMounts = {
    "/home" = {
      hostPath = "/srv/gnucash";
      isReadOnly = false;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0";
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
	gnucash
	awscli
	backup-utils
      ];
    };
  };
  tmpfs = [ "/home" ];
}
