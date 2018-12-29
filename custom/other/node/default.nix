{
  pkgs ? import <nixpkgs>{},
  node ? pkgs.nodejs,
  node-packages ? ""
}:
stdenv.mkDerivation {
  name = "node";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper node ];
  installPhase = ''
    mkdir $out &&
    makeWrapper \
      ${node}/bin/node \
      $out/bin/node &&
    makeWrapper \
      ${node}/bin/npm \
      $out/bin/npm &&
    true
  '';
}
