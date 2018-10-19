{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}

    set -e
    echo hello
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
  contents = [ pkgs.coreutils ];
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
  };
}