{
  pkgs ? import <nixpkgs> {},
  name ? "xchromium",
  version ? "44"
}:
pkgs.stdenv.mkDerivation {
  name = "${name}-${version}";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    makeWrapper \
      ${pkgs.chromium}/bin/chromium \
      ${name} &&
      true
  '';
}
