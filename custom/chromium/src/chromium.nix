{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeShellScriptBin "entrypoint.sh" ''
    ${pkgs.chromium}/bin/chromium
  '';
in
dockerTools.buildImage {
  name = "chromium";
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    mkdir /home &&
      useradd --create-home chromium &&
      true
  '';
  contents = [ pkgs.chromium ];
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
  };
}