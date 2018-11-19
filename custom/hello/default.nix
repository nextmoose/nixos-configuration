{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  custom-derivation = (import ../custom-derivation.nix);
in
custom-derivation {
  stdenv = stdenv;
  name = "hello";
  src = ./src;
}
