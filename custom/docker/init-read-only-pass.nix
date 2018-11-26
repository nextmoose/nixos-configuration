{ pkgs ? import <nixpkgs> {} }:
let
  read-only-pass = (import ../native/read-only-pass/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "read-only-pass";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home &&
      useradd --create-home user &&
      true
  '';
  config = {
    entrypoint = [ "${read-only-pass}/bin/read-only-pass" ];
    User = "user";
  };
}