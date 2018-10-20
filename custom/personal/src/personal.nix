{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}
    ${gnome3.gnome-terminal}/bin/gnome-terminal
  '';
in
dockerTools.buildImage {
  name = "personal";
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    mkdir /home &&
      useradd --create-home user &&
      true
  '';
  contents = [ pkgs.gnome3.gnome-terminal pkgs.firefox ];
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
  };
}