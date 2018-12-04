{
  pkgs ? import <nixpkgs> {},
  name,
  image
}:
{
  description = "X2 Docker Image Pull -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "${pkgs.docker}/bin/docker image ls";
  };
  wantedBy = [ "default.target"];
}
