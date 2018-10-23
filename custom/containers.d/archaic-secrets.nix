{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  personal = (import ../expressions/personal/default.nix { inherit pkgs; });
  secrets = (import ../expressions/secrets/default.nix { inherit pkgs; });
in
{
  bindMounts = {
    "/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs" = {
      hostPath = "/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs";
      isReadOnly = true;
    };
    "/nix/var/nix/profiles/per-user/root/channels" = {
      hostPath = "/nix/var/nix/profiles/per-user/root/channels";
      isReadOnly = true;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0.0";
    hardware.pulseaudio.enable = true;
    programs = {
      bash.loginShellInit = ''
        ${secrets}/bin/initialize \
	  --canonical-host github.com \
	  --canonical-organization nextmoose \
	  --canonical-repository secrets \
	  --canonical-branch master \
	  --upstream-host github.com \
	  --upstream-user git \
	  --upstream-port 22 \
	  --origin-host github.com \
	  --origin-user git \
	  --origin-port 22 \
	  --report-host github.com \
	  --report-user git \
	  --report-port 22 \
	  &&
	  ${secrets}/bin/init-pass \
	    --origin-organization desertedscorpion \
	    --origin-repository passwordstore \
	    --origin-branch master &&
	  true
      '';
    };
    security.sudo.wheelNeedsPassword = false;
    services.mingetty.autologinUser = "user";
    sound.enable = true;
    users.extraUsers.user = {
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      packages = [
#	personal
	nixos-container
        coreutils
	firefox
	emacs
	chromium
	secrets
	pass
#	(import ../expressions/chromium/default.nix { inherit pkgs; })	
      ];
    };
  };
  tmpfs = [ "/home" ];
}
