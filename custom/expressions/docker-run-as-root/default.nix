{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "docker-root";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      makeWrapper $out/scripts/runAsRoot.sh $out/bin/runAsRoot --set PATH ${lib.makeBinPath [ shadowSetup coreutils ]} &&
      true
  '';
}
