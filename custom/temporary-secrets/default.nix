{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  old-secrets = (import ../../installed/init-read-only-pass/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "setup";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/lib &&
      tar ${old-secrets}/etc/xvzf file.tar.gz --director $out/lib &&
      true
  '';
}
