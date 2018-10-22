{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  personal = (import ../expressions/builder/default.nix { inherit pkgs; });
in
{
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
	pass
      ];
    };
  };
}
