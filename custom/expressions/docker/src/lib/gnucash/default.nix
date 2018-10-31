{ pkgs ? import <nixpkgs> {} }:
let
  fedora = pkgs.dockerTools.pullImage {
    imageName = "fedora";
    imageTag = "29";
    sha256 = "16nc7sl0kr3z5gz094h2a26mn0wd7s7vsql95zvljc1zrw7aai96";
  };
  entrypoint = pkgs.writeScript "entrypoint.sh" ''
     #!${pkgs.stdenv.shell}
     ${pkgs.gnucash}/bin/gnucash
  '';
in
with pkgs;
dockerTools.buildImage {
  name = "gnucash";
  fromImage = fedora;
  fromImageName = "fedora";
  fromImageTag = "29";
  runAsRoot = ''
    echo hello world
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
    WorkingDir = "/home/user";
  };
}
