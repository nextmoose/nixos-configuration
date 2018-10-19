{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
stdenv.mkDerivation rec {
  name = "containerized-read-only-pass";
  src = ./src;
  buildInputs = [ makeWrapper ];
  buildPhase = ''
    nix-build read-only-pass.nix
  '';
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      cp result $out/etc/result &&
      mkdir $out/scripts &&
      cp read-only-pass.sh $out/scripts &&
      chmod 0500 $out/scripts/read-only-pass.sh &&
      makeWrapper $out/scripts/read-only-pass.sh $out/bin/read-only-pass --set PATH ${lib.makeBinPath [ docker ]} --set STORE_DIR $out &&
      true
  '';
}
