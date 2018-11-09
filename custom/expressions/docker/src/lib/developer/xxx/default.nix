{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "xxx";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive lib scripts $out &&
      chmod 0400 $out/lib/* &&
      chmod 0500 $out/scripts/* &&
      makeWrapper $out/scripts/entrypoint.sh $out/bin/entrypoint --set PATH ${lib.makeBinPath [ coreutils bash git ]} --set STORE_DIR "$out" &&
      true
  '';
}
