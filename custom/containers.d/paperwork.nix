{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  backup-utils = (import ../expressions/backup-utils/default.nix { inherit pkgs; });
  container-initializations = (import ../expressions/container-initializations/default.nix { inherit pkgs; });
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
    environment.variables = {
      BUCKET="21b04328-e349-4d42-b1a7-872ac295bc68";
      DISPLAY=":0";
    };
    services.mingetty.autologinUser = "user";
    programs.bash.shellInit = "${container-initializations}/bin/paperwork";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        paperwork
	awscli
	backup-utils
      ];
    };
  };
#  tmpfs = [ "/home" ];
}
