{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "gnucash";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/lib &&
      cp gconf.path $out/lib &&
      chmod 0400 $out/lib &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/gnucash $out/bin/gnucash --set PATH ${lib.makeBinPath [ gnucash mktemp ]} --set STORE_DIR "$out" &&
      true
  '';
}
