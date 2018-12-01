{ pkgs ? import <nixpkgs> {} }:
let
  depot_tools = (import ../depot_tools/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "fetch-chromium-source";
  src = ./src;
  buildInputs = [ makeWrapper depot_tools ] ;
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/fetch-chromium-source.sh \
        $out/bin/fetch-chromium-source \
        --set PATH ${pkgs.lib.makeBinPath [ depot_tools ]} &&
      true
  '';
}
