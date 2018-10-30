{ pkgs ? import <nixpkgs> {} }:
let
  entrypoint = pkgs.writeScript "entrypoint.sh" ''
     #!${pkgs.stdenv.shell}
     ${pkgs.coreutils}/bin/echo hello
  '';
in
with pkgs;
dockerTools.buildImage {
  name = "gnucash";
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    adduser user
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
  };
}
