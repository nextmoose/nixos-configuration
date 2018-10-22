{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
{
  enable = true;
  autoPrune = {
    enable = true;
    flags = [ "--all" ];
    dates = "daily";
  };
}