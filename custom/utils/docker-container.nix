{
  pkgs ? import <nixpkgs> {},
  image,
  name,
  privileged ? false,
  arguments ?  ""
}:
let
  privileged-flag = (if privileged then "--privileged" else "");
in
{
  description = "Docker Container Service -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "simple";
    ExecStart = ''
      ${pkgs.docker}/bin/docker \
        container \
        run \
        ${privileged-flag} \
        --interactive \
        --rm \
        --env DISPLAY \
        --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0 \
        --name ${name} \
        ${image} \
        ${arguments}
      '';
    ExecStop = "${pkgs.docker}/bin/docker container stop ${name}";
    RemainAfterExit = "yes";
  };
  after = [ "docker-image-${name}.service" ] ;
  requires = [ "docker-image-${name}.service" ] ;
  wantedBy = [ "default.target"];
}
