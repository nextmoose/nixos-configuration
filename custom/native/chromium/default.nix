{ pkgs ? import <nixpkgs> {} }:
let
  depot_tools = (import ../depot_tools/default.nix {});
  fetch-chromium-source = pkgs.writeShellScriptBin "fetch-chromium-source" ''
    fetch --nohooks --no-history chromium
  '';
in
pkgs.stdenv.mkDerivation {
  name = "chromium";
  src = fetch-chromium-source {
  };
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
