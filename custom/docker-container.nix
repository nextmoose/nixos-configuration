{
  pkgs ? import <nixpkgs> {},
  name,
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
  after = [ "${image}" ];
  requires = [ "${image}" ];
  wantedBy = [ "default.target" ];
}