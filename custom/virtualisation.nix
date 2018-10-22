{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
{
  docker = (import ./custom/virtualisation.d/docker.nix { inherit pkgs; });
  virtualbox = (import ./custom/virtualisation.d/virtualbox.nix { inherit pkgs; });
}