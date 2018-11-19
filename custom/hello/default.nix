{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  custom-derivation = (import ../custom-derivation.nix);
in
custom-derivation {
  name = "hello";
  src = ./src;
}
