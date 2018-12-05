{
  pkgs ? import <nixpkgs> {},
  name,
  entrypoint,
  cmd ? []
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
    config = {
      entrypoint = entrypoint;
      cmd = cmd;
      User = "user";
    };
  };
in
{
  description = "X5 Docker Image Load -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "${docker-image-load}/bin/docker-image-load ${image}";
    ExecStop = "${pkgs.docker}/bin/docker image rm --force ${name}";
  };
  wantedBy = [ "default.target"];
}
