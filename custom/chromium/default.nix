{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "chromium";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      mkdir $out/scripts &&
      cp chromium.sh $out/scripts &&
      chmod 0500 $out/scripts/chromium.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/chromium.sh $out/bin/chromium --set PATH ${lib.makeBinPath [ chromium coreutils gnugrep ]} &&
      true
  '';
}
