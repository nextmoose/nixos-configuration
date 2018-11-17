{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  configuration-utils = (import ../configuration-utils/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "create-install-media";
  src = ./src;
  buildInputs = [ makeWrapper ];
  buildPhase = "${configuration-utils}/bin/build-phase"
  installPhase = "${configuration-utils}/bin/install-phase"
}
