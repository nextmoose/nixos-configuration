{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
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
      ];
    };
  };
  tmpfs = [ "/home" ];
}
