{
  pkgs ? import <nixpkgs> {},
  name,
  image
}:
{
  description = "Docker Image Pull -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "cat ${image} | docker image load";
  };
  wantedBy = [ "default.target"];
}
