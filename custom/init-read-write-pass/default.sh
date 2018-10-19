{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  initreadonlypass = 
  postcommit = writeShellScriptBin "post-commit" ''
    while ! git push origin $(git rev-parse --abbrev-ref HEAD --)
    do
      sleep 1s
    done
  '';
in
stdenv.mkDerivation rec {
  name = "init-read-write-pass";
  src = ./src;
  buildInputs = [ makeWrapper ];
  buildPhase = ''
  '';
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      cp secrets.tar.gz $out/etc &&
      mkdir $out/scripts &&
      cp init-read-only-pass.sh $out/scripts &&
      chmod 0500 $out/scripts/init-read-only-pass.sh &&
      makeWrapper $out/scripts/init-read-only-pass.sh $out/bin/init-read-only-pass --set PATH ${lib.makeBinPath [ mktemp coreutils gzip gnutar gnupg pass postcommit which ]} --set STORE_DIR $out &&
      true
  '';
}
