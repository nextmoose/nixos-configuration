{ pkgs ? import <nixpkgs> {} }:
pkgs.dockerTools.buildImage {
  contents = [ ];
  name = "emacs";
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
    cmd = [];
    entrypoint = [ "${pkgs.emacs}/bin/emacs" ];
    User = "user";
  };
}
