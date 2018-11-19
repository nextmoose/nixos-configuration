{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "node";
  src = pkgs.fetchurl {
    url = "https://nodejs.org/dist/latest-v8.x/node-v8.12.0-linux-x64.tar.gz";
    sha512 = "1pchax0s70ckwcq35pj2c89iv3pdkk9a7j9q429qnnn4g5dri772bjvy3mv2fcr4qkm1x3p8xn4s6icszxg3hsa1k6mpz73p4icq7z3";
  };
  installPhase = "cp --recursive . $out";
}
