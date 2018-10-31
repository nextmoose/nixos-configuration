{ pkgs ? import <nixpkgs> {} }:
let
  fedora = pkgs.dockerTools.pullImage {
    imageName = "fedora";
    imageTag = "29";
    digest = "fedora@sha256:5c2fbd86f7de07ae71d85e7827b0c22180b9b83974d836cb105e09ec26627ec3";
    sha256 = "16nc7sl0kr3z5gz094h2a26mn0wd7s7vsql95zvljc1zrw7aai96";
  };
  entrypoint = pkgs.writeScript "entrypoint.sh" ''
     #!${pkgs.stdenv.shell}
     ${pkgs.gnucash}/bin/gn
  '';
in
with pkgs;
dockerTools.buildImage {
  name = "gnucash";
  fromImage = fedora;
  fromImageName = "fedora";
  fromImageTag = "29";
  runAsRoot = ''
    dnf update --assumeyes &&
      true
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
    WorkingDir = "/home/user";
  };
}
