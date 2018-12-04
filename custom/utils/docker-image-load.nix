{
  pkgs ? import <nixpkgs> {},
  name
}:
let
  docker-image-load = (import ../native/docker-image-load/default.nix {} );
  image = pkgs.dockerTools.buildImage {
    name = "${name}";
    runAsRoot = ''
      ${pkgs.dockerTools.shadowSetup}
        mkdir /home &&
        useradd --create-home user &&
        true
    '';
  };
in
{
  description = "X4 Docker Image Pull -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "${docker-image-load}/bin/docker-image-load ${image}";
    ExecStop = "${pkgs.coreutils}/bin/echo ${pkgs.docker}/bin/docker image rm ${name}";
  };
  wantedBy = [ "default.target"];
}
