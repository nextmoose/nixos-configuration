{
  pkgs
} :
pkgs.stdenv.mkDerivation {
  name = "testing";
  src = ./src;
  buildInputs = [];
  installPhase = ''
  '';
}