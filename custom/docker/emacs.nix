{ pkgs ? import <nixpkgs> {} }:
let
  emacs = (import ../native/emacs/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "emacs";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      chmod a+rwx /tmp &&
      useradd --create-home user &&
      mkdir /usr &&
      mkdir /usr/bin &&
      ln --symbolic ${pkgs.coreutils}/bin/env /usr/bin &&
      true
  '';
  config = {
    entrypoint = [ "${emacs}/bin/emacs" ];
    ExposedPorts = {
      "8080/tcp" = {};
    };
    User = "user";
    WorkingDir = "/home/user";
  };
}