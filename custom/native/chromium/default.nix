{ pkgs ? import <nixpkgs> {} }:
let
  fetch-chromium-source = (import ../fetch-chromium-source {});
in
pkgs.stdenv.mkDerivation {
  name = "chromium";
  inputSrcs = [ fetch-chromium-source ];
  src = "fetch-chromium-source";
  buildInputs = [ pkgs.makeWrapper fetch-chromium-source ] ;
  buildPhase = ''
    cd src &&
      true
  '';
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      touch $out/wtf.sh &&
      chmod a+rx $out/wtf.sh &&
      true
  '';
}
