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
  name = "${name}";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
  '';
}
