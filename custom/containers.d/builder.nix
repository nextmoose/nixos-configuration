{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  personal = (import ../expressions/builder/default.nix { inherit pkgs; });
in
{
  additionalCapabilities = [ "CAP_SYS_RAWIO" ];
  bindMounts = {
    "/home/user/projects" = {
      hostPath = "/home/user/projects";
      isReadOnly = false;
    };
    "/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs" = {
      hostPath = "/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs";
      isReadOnly = true;
    };
    "/nix/var/nix/profiles/per-user/root/channels" = {
      hostPath = "/nix/var/nix/profiles/per-user/root/channels";
      isReadOnly = true;
    };
    "/dev/mapper" = {
      hostPath = "/dev/mapper";
      isReadOnly = false;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0.0";
    security.sudo.wheelNeedsPassword = false;
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      packages = [
        personal
	virtualbox
	lvm2
	devicemapper
	pass
      ];
    };
  };
}
