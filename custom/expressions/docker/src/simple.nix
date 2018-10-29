{ pkgs ? import <nixpkgs> {} }:
let
  entrypoint = pkgs.writeScript "entrypoint.sh" ''
     #!${pkgs.stdenv.shell}
     ${pkgs.coreutils}/bin/echo hello
  '';
in
with pkgs;
dockerTools.buildImage {
  name = "simple";
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
  };
}
