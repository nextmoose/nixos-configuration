{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "development";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive lib $out/lib &&
      chmod 0400 $out/lib/* &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/development.sh $out/bin/development --set PATH ${lib.makeBinPath [ docker coreutils pass gnupg git ]} &&
      true
  '';
}
