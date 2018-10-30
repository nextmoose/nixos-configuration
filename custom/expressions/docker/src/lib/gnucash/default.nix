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
  contents = [ pkgs.bash pkgs.gnucash pkgs.coreutils ];
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    chmod a+rwx /tmp &&
      mkdir /home &&
      ${pkgs.shadow}/bin/useradd --create-home user
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
    WorkDir = "/home/user";
  };
}
