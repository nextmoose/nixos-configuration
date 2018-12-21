{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  name = "zoom";
  src = pkgs.fetchurl {
    url = "https://www.zoom.us/client/latest/zoom_x86_64.tar.xz";
  };
}