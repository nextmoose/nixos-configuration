{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "personal";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      cp personal.nix $out/etc &&
      mkdir $out/scripts &&
      cp personal.sh $out/scripts &&
      chmod 0500 $out/scripts/personal.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/personal.sh $out/bin/personal --set PATH ${lib.makeBinPath [ docker mktemp coreutils ]} --set STORE_DIR $out &&
      true
  '';
}
