{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "create-install-media";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/create-install-media.sh $out/bin/create-install-media --set PATH ${lib.makeBinPath [ lvm2 ]} --set STORE_DIR $out &&
      true
  '';
}
