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
  contents = [ gnucash shadow bash ];
  runAsRoot = ''
     #!${stdenv.shell}
     ${dockerTools.shadowSetup}
     mkdir /home /tmp &&
       useradd --create-home user &&
       chmod a+rwx /tmp &&
       true
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ "${gnucash}/bin/gnucash" ];
    User = "user";
    WorkingDir = "/home/user";
  };
}
