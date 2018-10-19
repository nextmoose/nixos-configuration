{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  wifi = (import ../../installed/init-wifi/default.nix { inherit pkgs; });
  initreadonlypass = (import ../../installed/init-read-only-pass/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "initialize-user-experience";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp init-user-experience.sh $out/scripts &&
      chmod 0500 $out/scripts/init-user-experience.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/init-user-experience.sh $out/bin/init-user-experience --set PATH ${lib.makeBinPath [ wifi initreadonlypass coreutils pass git which ]} --set STORE_DIR $out &&
      true
  '';
}
