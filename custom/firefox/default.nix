{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "firefox";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      cp firefox.nix $out/etc &&
      mkdir $out/scripts &&
      cp firefox.sh $out/scripts &&
      chmod 0500 $out/scripts/firefox.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/firefox.sh $out/bin/firefox --set PATH ${lib.makeBinPath [ docker mktemp coreutils ]} --set STORE_DIR $out &&
      true
  '';
}
