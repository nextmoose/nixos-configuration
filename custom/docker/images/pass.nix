{ pkgs ? import <nixpkgs> {} }:
let
  pass = (import ../../../native/pass/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "pass";
  contents = [ pkgs.shadow pkgs.pass pkgs.bash pkgs.coreutils pkgs.openssh ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      useradd --create-home user &&
      chmod 0777 /tmp &&
      true
  '';
  config = {
    entrypoint = [ "${pass}/bin/pass" ];
    User = "user";
  };
}
