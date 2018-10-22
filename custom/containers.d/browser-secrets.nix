{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  secrets = (import ../expressions/secrets/default.nix { inherit pkgs; });
in
{
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0";
    programs.bash.shellInit = ''
      ${secrets}/bin/init-read-write-pass \
	--origin-host github.com \
	--origin-port 22 \
	--origin-user git \
	--origin-organization nextmoose \
	--origin-repository browser-secrets \
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
	pkgs.pass
	secrets
      ];
    };
  };
  tmpfs = [ "/home" ];  
}