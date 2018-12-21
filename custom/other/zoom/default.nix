{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  name = "zoom";
  src = pkgs.fetchurl {
    url = "https://www.zoom.us/client/latest/zoom_x86_64.tar.xz";
    sha256 = "0bs5kx2601lwwr9lgdd3hlbrrwsf0dai766zrca907dl400pmzyd";
  };
  buildRequires = [ pkgs.bash ];
  buildPhase = "./ZoomLauncher";
}