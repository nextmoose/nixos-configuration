{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "node";
  src = pkgs.fetchFromUrl {
    url = "http://nodejs.org/dist/v11.2.0/node-v11.2.0.tar.gz";
  };
  buildInputs = [ pkgs.gnutar ];
  installPhase = ''
    tar --extract --gzip --file . --directory $out &&
      true
  '';
}
