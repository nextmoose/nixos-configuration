{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "node";
  src = pkgs.fetchurl {
    url = "https://nodejs.org/dist/v10.13.0/node-v10.13.0.tar.gz";
    sha512 = "308rnwala6jb9k928qb7n1y828kd79m6aqmcv9p53isd5yg1mgxgm25hvwkgjxwv2br382wnfgdf18nin8yppk0n14b77vs8rkcjc7c";
  };
  buildInputs = [ pkgs.python ];
  buildPhase = ''
    ./configure &&
      make -j4
  '';
  installPhase = "
    make install PREFIX=$out
  ";
}
