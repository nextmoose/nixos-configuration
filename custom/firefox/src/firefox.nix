{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}
    ${pkgs.firefox}/bin/firefox
  '';
in
dockerTools.buildImage {
  name = "firefox";
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    mkdir /home &&
      useradd --create-home user &&
      true
  '';
  contents = [ pkgs.firefox pkgs.gnugrep pkgs.coreutils ];
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
  };
}