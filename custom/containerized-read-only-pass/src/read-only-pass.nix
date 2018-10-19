{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''nix
    ${pkgs.bash}/bin/bash
  '
in
dockerTools.buildImage {
  name = "read-only-pass";
  runAsRoot = ''
    ${dockerTools.shadowSetup}
    mkdir /home &&
      useradd --create-home user
  '';
  contents = [ pkgs.bash ];
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
  };
}