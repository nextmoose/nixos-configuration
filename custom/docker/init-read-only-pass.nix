{ pkgs ? import <nixpkgs> {} }:
let
  utilities = (import ../native/utilities/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "init-read-only-pass";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home &&
      useradd --create-home user &&
      true
  '';
  config = {
    entrypoint = [ "${utilities}/bin/init-read-only-pass" ];
    User = "user";
  };
}