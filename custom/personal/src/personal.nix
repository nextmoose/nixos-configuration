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
  contents = [ pkgs.gnome3.gnome-terminal pkgs.firefox  pkgs.dbus pkgs.dbus_daemon pkgs.dbus_libs pkgs.dbus_tools pkgs.dbus-broker ];
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
    WorkDir = "/home/user";
  };
}