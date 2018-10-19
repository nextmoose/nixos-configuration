{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  wifi = (import ../../installed/init-wifi/default.nix { inherit pkgs; });
  initreadonlypass = (import ../../installed/init-read-only-pass/default.nix { inherit pkgs; });
  postcommit = writeShellScriptBin "post-commit" ''
    while ! git push origin $(git rev-parse --abbrev-ref HEAD --)
    do
	sleep 1s
    done
  '';
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
      makeWrapper $out/scripts/init-user-experience.sh $out/bin/init-user-experience --set PATH ${lib.makeBinPath [ wifi initreadonlypass coreutils pass git which postcommit ]} --set STORE_DIR $out &&
      true
  '';
}
