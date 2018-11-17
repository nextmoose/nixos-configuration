{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  configuration-utils = (import ../configuration-utils/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "hello";
  src = ./src;
  buildInputs = [ configuration-utils ];
  buildPhase = "build-phase";
  installPhase = "install-phase";
}
