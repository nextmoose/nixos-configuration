{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "node";
  src = pkgs.fetchurl {
    url = "https://nodejs.org/dist/v10.13.0/node-v10.13.0-linux-x64.tar.xz";
    sha512 = "00j60jx7iv9i5d2jf5bb46vwfvj5s1ns8wpikb55rflrd0m0hhg773yl3kf0r4lidh2g0lmn71kc7xhb7a8iprm1ww8gb4dy7x0xsn3";
  };
  installPhase = ''
    cp --recursive . $out &&
      true
  '';
}
