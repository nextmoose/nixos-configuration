{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  backup-utils = (import ../expressions/backup-utils/default.nix { inherit pkgs; });
  container-initializations = (import ../expressions/container-initializations/default.nix { inherit pkgs; });
  my-gnucash = (import ../expressions/gnucash/default.nix { inherit pkgs; });
in
{
  bindMounts = {
    "/srv/lib" = {
      hostPath = "/home/user/projects/configuration/custom/expressions/container-initializations/src/lib/";
      isReadOnly = false;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables = {
      BUCKET="e613b6bb-3d0b-4d02-8af9-6b05a3c89d3e";
      DISPLAY=":0";
    };
    services.mingetty.autologinUser = "user";
    programs.bash.shellInit = ''
      if [ ! -f /home/user/.gconf.path ]
      then
        ${container-initializations}/bin/gnucash-2 &&
	  ${backup-utils}/bin/debucket --timestamp 1540656743 --bucket e613b6bb-3d0b-4d02-8af9-6b05a3c89d3e --destination-directory gnucash &&
	  echo AAA > log.txt &&
          # gnucash gnucash/gnucash.gnucash &&
	  echo BBB >> log.txt &&
	  true
      fi &&
        true
    '';
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        gnucash
#	my-gnucash
	awscli
	backup-utils
	container-initializations
	gnupg
      ];
    };
  };
  tmpfs = [ "/home" ];
}
