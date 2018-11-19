{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "node";
  src = pkgs.fetchurl {
    url = "https://nodejs.org/dist/v10.13.0/node-v10.13.0-linux-x64.tar.xz";
    sha512 = "32av727sv4bjnncha4aqwip2yyd6bmr3dxsq97zns877wba8bhg44f6br4mlx6mv50bj47w0i48hwkxiv0g2yg95800dmrcali3x08l";
  };
  installPhase = ''
    cp --recursive . $out &&
      true
  '';
}
