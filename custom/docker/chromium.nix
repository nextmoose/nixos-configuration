{ pkgs ? import <nixpkgs> {} }:
let
  chromium = pkgs.chromium;
in
pkgs.dockerTools.buildImage {
  contents = [ pkgs.gnugrep pkgs.coreutils pkgs.bash pkgs.chromium ];
  name = "chromium";
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp /usr &&
      mkdir /usr/bin &&
      useradd --create-home user &&
      chmod a+rwx /tmp &&
      ln --symbolic ${pkgs.bash}/bin/env /usr/bin &&
      true
  '';
  config = {
    cmd = [ "--version" ];
    entrypoint = [ "${chromium}/bin/chromium" ];
    User = "user";
    WorkingDir = "/home/user";
  };
}