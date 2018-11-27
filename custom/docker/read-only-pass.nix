{ pkgs ? import <nixpkgs> {} }:
let
  health-check = (import ../native/health-check/default.nix {});
  read-only-pass = (import ../native/read-only-pass/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "read-only-pass";
  contents = [ pkgs.shadow pkgs.pass health-check pkgs.bash pkgs.coreutils ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      useradd --create-home user &&
      chmod 0777 /tmp &&
      true
  '';
  config = {
    entrypoint = [ "${read-only-pass}/bin/read-only-pass" ];
    healthCheck = {
      Test = [ "${health-check}/bin/health-check" ];
      Interval = 30000000000;
      Timeout = 10000000000;
      Retries = 3;
    };
    User = "user";
  };
}