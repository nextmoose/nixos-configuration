{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
{
  host.enable = true;
}