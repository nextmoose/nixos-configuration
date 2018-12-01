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
    mkdir $out &&
      mkdir $out/bin &&
      makeWrapper \
        ${pkgs.chromium}/bin/chromium \
        $out/bin/${name} &&
      true
  '';
}
