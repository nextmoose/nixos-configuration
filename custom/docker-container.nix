{
  pkgs ? import <nixpkgs> {},
  image
}:
{
  description = "Docker Container Service -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.docker}/bin/docker container ls";
    ExecStop = "${pkgs.docker}/bin/docker container ls";
  };
  after = [ "docker.service" "${image}" ];
  requires = [ "docker.service" "${image}" ];
  wantedBy = [ "default.target" ];
}