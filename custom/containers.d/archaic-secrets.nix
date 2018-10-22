{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  init-read-write-pass = (import ../init-read-write-pass/default.nix { inherit pkgs; });
in
{
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0";
    programs.bash.shellInit = ''
      ${init-read-write-pass}/bin/init-read-write-pass \
	--origin-host github.com \
	--origin-port 22 \
	--origin-user git \
	--origin-organization desertedscorpion \
	--origin-repository passwordstore \
	--origin-branch master \
	--committer-name "Emory Merryman" \
	--committer-email emory.merryman@gmail.com \
	&&
	true
      '';
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        pkgs.browserpass
	pkgs.pass
	(import ../chromium/default.nix { inherit pkgs; })
	  pkgs.coreutils
      ];
    };
  };
  tmpfs = [ "/home" ];  
}