{ pkgs ? import <nixpkgs> {} }:
let
  read-only-pass = (import ../native/read-only-pass/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "read-only-pass";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      useradd --create-home user &&
      chmod 0777 /tmp &&
      true
  '';
  config = {
    entrypoint = [ "${read-only-pass}/bin/read-only-pass" ];
    User = "user";
  };
}