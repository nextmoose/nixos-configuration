{
  pkgs ? import <nixpkgs> {},
  name,
  uuid,
  origin-repository
}:
let
  pass = (import ../../../installed/pass/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "${pass}";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    echo HELLO WORLD &&
    echo ALPHA 00100 &&
      true
  '';
}
