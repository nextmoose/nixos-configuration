{
  pkgs ? import <nixpkgs> {},
}:
{
  description = "Docker Container Service -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.docker}/bin/docker container
  };
  after = [ "docker.service" ];
  requires = [ "docker.service" ];
  wantedBy = [ "default.target" ];
}