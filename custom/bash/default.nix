{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "bash";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      cp bash.nix $out/etc &&
      mkdir $out/scripts &&
      cp bash.sh $out/scripts &&
      chmod 0500 $out/scripts/bash.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/bash.sh $out/bin/my-bash --set PATH ${lib.makeBinPath [ docker mktemp coreutils ]} --set STORE_DIR $out &&
      true
  '';
}
