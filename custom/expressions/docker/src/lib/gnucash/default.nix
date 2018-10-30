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
  contents = [ pkgs.bash pkgs.gnucash pkgs.coreutils pkgs.gtk2-x11 ];
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
      mkdir /home /tmp &&
      ${pkgs.shadow}/bin/useradd --create-home user &&
      chmod a+rwx /tmp &&
      true
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
    WorkingDir = "/home/user";
  };
}
