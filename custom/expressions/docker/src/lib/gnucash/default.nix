{ pkgs ? import <nixpkgs> {} }:
let
  entrypoint = pkgs.writeScript "entrypoint.sh" ''
     #!${pkgs.stdenv.shell}
     ${pkgs.gnucash}/bin/gnucash
  '';
in
with pkgs;
dockerTools.buildImage {
  name = "gnucash";
  contents = [ pkgs.bash pkgs.gnucash ];
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    ${pkgs.shadow}/bin/useradd --create-home user
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
    WorkDir = "/home/user";
  };
}
