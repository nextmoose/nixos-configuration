{ pkgs ? import <nixpkgs> {} }:
let
  read-write-pass = (import ../../read-write-pass/default.nix {});
  health-check = (import ../../health-check/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "pass";
  contents = [ pkgs.shadow pkgs.pass health-check pkgs.bash pkgs.coreutils pkgs.openssh ];
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
      Interval = 3000000000;
      Timeout = 1000000000;
      Retries = 30;
    };
    User = "user";
  };
}
