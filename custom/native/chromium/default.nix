{ pkgs ? import <nixpkgs> {} }:
let
  depot_tools = (import ../depot_tools/default.nix {});
  fetch-chromium-source = writeShellScriptBin "fetch-chromium-source" ''
    mkdir src &&
      fetch --nohooks --no-history chromium
      echo src &&
      true
  '';
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
