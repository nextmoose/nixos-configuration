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
      useradd --create-home user
  '';
  config = {
    entrypoint = [ "${emacs}/bin/emacs" ];
    User = "user";
    ExposedPorts = {
      "8080/tcp" = {};
    };
  };
}