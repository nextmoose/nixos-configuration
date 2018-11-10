{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  xxx = dockerTools.buildImage {
    name = "xxx";
    contents = [ shadow bash coreutils ];
    runAsRoot = ''
     #!${stdenv.shell}
     ${dockerTools.shadowSetup}
     mkdir /home /tmp &&
       useradd --create-home user &&
       chmod a+rwx /tmp &&
       true    
    '';
    config = {
      Cmd = [ ];
      Entrypoint = [ bash ];
      User = "user";
      WorkingDir = "/home/user";
    };
  };
in
stdenv.mkDerivation rec {
  name = "docker";
  src = ./src;
  buildInputs = [ makeWrapper which docker sudo ];
  buildPhase = ''
    ls lib/developer/default.nix &&
      true
  '';
  installPhase = ''
    mkdir $out &&
      cp --recursive lib $out/lib &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      true
  '';
}
