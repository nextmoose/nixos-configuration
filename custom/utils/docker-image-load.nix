{
  pkgs ? import <nixpkgs> {},
  name,
  image
}:
let
  docker-image-load = (import ../native/docker-image-load/default.nix {} );
in
{
  description = "X3 Docker Image Pull -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "${docker-image-load}/bin/docker-image-load ${image}";
  };
  wantedBy = [ "default.target"];
}
