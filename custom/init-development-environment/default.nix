{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  init-read-only-pass = (import ../../installed/init-read-only-pass/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "init-development-environment";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp init-development-environment.sh post-commit.sh pre-push.sh $out/scripts &&
      chmod 0500 $out/scripts/init-development-environment.sh $out/scripts/post-commit.sh $out/pre-push.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/init-development-environment.sh $out/bin/init-development-environment --set PATH ${lib.makeBinPath [ init-read-only-pass pass git coreutils ]} &&
      makeWrapper $out/scripts/post-commit.sh $out/bin/post-commit --set PATH ${lib.makeBinPath [ git coreutils ]} &&
      makeWrapper $out/scripts/post-commit.sh $out/bin/pre-push --set PATH ${lib.makeBinPath [ coreutils ]} &&
      true
  ''; 
}
