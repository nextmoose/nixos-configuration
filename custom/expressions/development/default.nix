{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  image = (import ../../docker.d/development.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "development";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/development.sh $out/bin/development --set PATH ${lib.makeBinPath [ docker coreutils "/run/wrappers" pass ]} --set IMAGE "${image}" &&
      makeWrapper $out/scripts/development.sh $out/bin/pitest --set PATH ${lib.makeBinPath [ docker coreutils "/run/wrappers" pass ]} --set COMMITTER_NAME "Emory Merryman" --set COMMITTER_EMAIL "emory.merryman@gmail.com" --set UPSTREAM_HOST github.com --set UPSTREAM_USER git --set UPSTREAM_PORT 22 --set UPSTREAM_ORGANIZATION hcoles --set UPSTREAM_REPOSITORY pitest --set UPSTREAM_BRANCH master --set ORIGIN_HOST github.com --set ORIGIN_USER git --set ORIGIN_HOST github.com --set ORIGIN_PORT 22 --set ORIGIN_ORGANIZATION hcoles --set ORIGIN_REPOSITORY pitest --set REPORT_HOST github.com --set REPORT_USER git --set REPORT_PORT 22 --set REPORT_ORGANIZATION hcoles --set REPORT_REPOSITORY pitest
      true
  '';
}
