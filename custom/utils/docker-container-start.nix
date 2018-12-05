{
  pkgs ? import <nixpkgs> {},
  image,
  name
}:
{
  description = "Docker Container Service -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "simple";
    ExecStart = "docker container run --interactive --tty --rm  --env DISPLAY --mount type=bind,source=/tmp/.X11-unix/X0,destination=/tmp/.X11-unix/X0 --name ${name} --label ${image}";
    ExecStop = "docker container stop ${name}";
    RemainAfterExit = "yes";
  };
  after = [ "docker-image-${name}.service" ] ;
  requires = [ "docker-image-${name}.service" ] ;
  wantedBy = [ "default.target"];
}
