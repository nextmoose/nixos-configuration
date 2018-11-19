{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "node";
  src = pkgs.fetchurl {
    url = "https://nodejs.org/dist/latest-v8.x/node-v8.12.0-linux-x64.tar.gz";
    sha512 = "1vajl0dm5rjgmw46i6iz6jbkdya9c7vag9w82fmhl7wnw52d3zm1g1f8yawdn4na111j2rjnjls47w1ilqhpv2kibz8xvfbwp2zf57m";
  };
  installPhase = "cp --recursive . $out";
}
