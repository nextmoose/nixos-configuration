{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
{
  guest = {
    enable = true;
    x11 = true;
  };
  host = {
    enable = true;
    enableHardening = true;
  };
}