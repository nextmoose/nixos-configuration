{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  configuration-utils = (import ../configuration-utils/default.nix { stdenv = pkgs.stdenv; });
in
configuration-utils.emory {
}
