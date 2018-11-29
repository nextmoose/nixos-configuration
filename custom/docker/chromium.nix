{ pkgs ? import <nixpkgs> {} }:
let
  chromium = pkgs.chromium;
in
pkgs.dockerTools.buildImage {
  contents = [ pkgs.gnugrep pkgs.coreutils pkgs.bash ];
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
    entrypoint = [ "${chromium}/bin/chromium" "--disable-gpu" ];
    User = "user";
  };
}