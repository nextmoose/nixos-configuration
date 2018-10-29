{ pkgs ? import <nixpkgs> {} }:
with pkgs;
dockerTools.buildImage {
  name = "cloud9";
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    ${pkgs.git}/bin/git clone https://github.com/c9/core.git c9sdk &&
    cd c9sdk &&
    sh ./scripts/install-sdk.sh
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ pkgs.bash ];
    ExposedPorts = {
      "8181/tcp" = {};
    };
  };
}