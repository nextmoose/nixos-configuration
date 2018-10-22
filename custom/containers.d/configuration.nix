{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  init-development-environment = (import ../init-development-environment/default.nix { inherit pkgs; });
in
{
  autoStart = false;
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0";
    programs.bash.shellInit = ''
      ${init-development-environment}/bin/init-development-environment \
        --upstream-host github.com \
        --upstream-user git \
	--upstream-port 22 \
	--upstream-organization rebelplutonium \
	--upstream-repository nixos-configuration \
	--upstream-branch master \
	--origin-host github.com \
	--origin-user git \
	--origin-port 22 \
	--origin-organization nextmoose \
	--origin-repository nixos-configuration \
	--origin-branch level-2 \
	--report-host github.com \
	--report-user git \
	--report-port 22 \
	--report-organization rebelplutonium \
	--report-repository nixos-configuration \
	--committer-name "Emory Merryman" \
	--committer-email emory.merryman@gmail.com \
	&&
	true
    '';
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
	pkgs.git
	  pkgs.emacs
      ];
    };
  };
  tmpfs = [ "/home" ];
}
