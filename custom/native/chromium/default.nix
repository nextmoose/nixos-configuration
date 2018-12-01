{
  pkgs ? import <nixpkgs> {},
  name ? "xchromium",
  version ? "44"
}:
let
  fetch-chromium-source = {}: derivation {
    name = "fetch-chromium-source";
    system = "mysystem";
    builder = ./fetch.sh;
  };
in
pkgs.stdenv.mkDerivation {
  name = "${name}-${version}";
  src = fetch-chromium-source {};
  buildInputs = [ pkgs.makeWrapper pkgs.coreutils ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      cat hello.txt &&
      ln --symbolic ${pkgs.chromium}/bin/chromium $out/bin/${name} &&
      ln --symbolic ${pkgs.chromium}/bin/chromium $out/bin/aaaa &&
      makeWrapper ${pkgs.chromium}/bin/chromium $out/bin/bbbb &&
      true
  '';
}
