{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "init-development-environment";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp firefox.sh $out/scripts &&
      chmod 0500 $out/scripts/init-development-environment.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/init-development-environment.sh $out/bin/init-develpment-environment --set PATH ${lib.makeBinPath [ init-read-only-pass pass git ]} --set STORE_DIR $out &&
      true
  '';
}
