{ pkgs ? import <nixpkgs> {} }:
let
  read-write-pass = (import ../native/read-write-pass/default.nix {});
  health-check = (import ../native/health-check/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "read-write-pass";
  contents = [ pkgs.shadow pkgs.pass ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      useradd --create-home user &&
      chmod 0777 /tmp &&
      true
  '';
  config = {
    entrypoint = [ "${read-write-pass}/bin/read-write-pass" ];
    healthCheck = {
      Test = [ "${health-check}/bin/health-check" ];
      Interval = 30000000000;
      Timeout = 10000000000;
      Retries = 3;
    };
    User = "user";
  };
}