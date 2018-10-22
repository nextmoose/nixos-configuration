{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
{
  docker = (import ./virtualisation.d/docker.nix { inherit pkgs; });
  virtualbox = (import ./virtualisation.d/virtualbox.nix { inherit pkgs; });
}