{
  pkgs ? import <nixpkgs> {},
  name ? "pass"
}:
{
  description = "Docker Container Start -- pass";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "docker container run --interactive --tty --rm pass";
  };
  wantedBy = [ "default.target"];
}
