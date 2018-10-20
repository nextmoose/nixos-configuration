{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}

    set -e
    ${pkgs.chromium}/bin/bash
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