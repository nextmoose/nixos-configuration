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
    ExecStart = "echo hi";
  };
  wantedBy = [ "default.target"];
}
