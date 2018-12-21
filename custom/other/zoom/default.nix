{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  name = "zoom";
  src = pkgs.fetchurl {
    url = "https://www.zoom.us/client/latest/zoom_x86_64.tar.xz";
    sha256 = "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824";
  };
}