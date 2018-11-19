{ pkgs ? import <nixpkgs> {} }:
let
  old-secrets = (import ../../../installed/init-read-only-pass/default.nix {});
in
pkgs.stdenv.mkDerivation rec {
  name = "setup";
  src = ./src;
  buildInputs = [ pkgs.gnutar ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/lib &&
      tar xvzf ${old-secrets}/etc/secrets.tar.gz --director $out/lib &&
      true
  '';
}
