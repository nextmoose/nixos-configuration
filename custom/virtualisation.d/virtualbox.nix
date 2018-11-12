{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
{
  guest = {
    enable = true;
    X11 = true;
  };
  host = {
    enable = true;
    enableHardening = true;
  };
}