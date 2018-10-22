{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}
    ${pkgs.chromium}/bin/chromium
  '';
in
dockerTools.buildImage {
  name = "chromium";
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    mkdir /home &&
      useradd --create-home user &&
      true
  '';
  contents = [ pkgs.chromium pkgs.gnugrep pkgs.coreutils ];
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
  };
}