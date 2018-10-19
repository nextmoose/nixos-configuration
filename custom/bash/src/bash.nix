{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}

    set -e
    ${pkgs.bash}/bin/bash
  '';
in
dockerTools.buildImage {
  name = "bash";
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    mkdir /home &&
      useradd --create-home user &&
      true
  '';
  contents = [ pkgs.coreutils pkgs.bash ];
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
  };
}