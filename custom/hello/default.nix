{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  configuration-utils = (import ../configuration-utils/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "hello";
  src = ./src;
  buildInputs = [ configuration-utils makeWrapper ];
  buildPhase = "build-phase --build-dir build";
  installPhase = ''
    install-phase --build-dir build --install-dir $out &&
      makeWrapper $out/scripts/hello.sh $out/bin/hello --set PATH ${lib.makeBinPath [ coreutils ]} &&
      true
  '';
}
