{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  initialization-utils = (import ../initialization-utils/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "container-initializations";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/browser-secrets.sh $out/bin/browser-secrets --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      makeWrapper $out/scripts/old-secrets.sh $out/bin/old-secrets --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      makeWrapper $out/scripts/configuration.sh $out/bin/configuration --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      true
  '';
}
