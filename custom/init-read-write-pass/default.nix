{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  init-read-only-pass = (import ../../installed/init-read-only-pass/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "init-read-write-pass";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp init-read-write-pass.sh post-commit.sh pre-push.sh $out/scripts &&
      chmod 0500 $out/scripts/init-read-write-pass.sh $out/scripts/post-commit.sh $out/scripts/pre-push.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/init-read-write-pass.sh $out/bin/init-read-write-pass --set PATH ${lib.makeBinPath [ init-read-only-pass pass git coreutils ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/post-commit.sh $out/bin/post-commit --set PATH ${lib.makeBinPath [ git coreutils ]} &&
      makeWrapper $out/scripts/pre-push.sh $out/bin/pre-push --set PATH ${lib.makeBinPath [ coreutils ]} &&
      true
  ''; 
}
