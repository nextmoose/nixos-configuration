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
      tar xvzf ${old-secrets}/etc/secrets.tar.gz --director $out/lib &&
      true
  '';
}
