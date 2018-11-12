{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "development";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive lib $out/lib &&
      chmod 0400 $out/lib/* &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/development.sh $out/bin/development --set PATH ${lib.makeBinPath [ coreutils pass gnupg git ]} &&
      makeWrapper $out/scripts/post-commit.sh $out/scripts/post-commit --set PATH ${lib.makeBinPath [ coreutils git ]} &&
      makeWrapper $out/scripts/development.sh $out/bin/pitest --set PATH ${lib.makeBinPath [ docker coreutils pass gnupg git ]} --set UPSTREAM_HOST github.com --set COMMITTER_NAME "Emory Merryman" --set COMMITTER_EMAIL "emory.merryman@gmail.com" --set UPSTREAM_USER git --set UPSTREAM_PORT 22 --set UPSTREAM_ORGANIZATION hcoles --set UPSTREAM_REPOSITORY pitest --set UPSTREAM_BRANCH master --set ORIGIN_USER git --set ORIGIN_PORT 22 --set ORIGIN_ORGANIZATION hcoles --set ORIGIN_REPOSITORY pitest --set REPORT_USER git --set REPORT_PORT 22 --set REPORT_ORGANIZATION hcoles --set REPORT_REPOSITORY pitest
      true
  '';
}
