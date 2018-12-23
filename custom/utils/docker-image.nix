{
  pkgs ? import <nixpkgs> {},
  name,
  entrypoint,
  cmd ? [],
  contents ? [],
  run ? ""
}:
let
  image = pkgs.dockerTools.buildImage {
    name = name;
    contents = contents;
    runAsRoot = ''
      ${pkgs.dockerTools.shadowSetup}
        mkdir /home /tmp &&
        useradd --create-home user &&
        chmod 0777 /tmp &&
	${run}
        true
    '';
    config = {
      entrypoint = entrypoint;
      cmd = cmd;
      User = "user";
    };
  };
in
{
  description = "Docker Image Service -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.docker}/bin/docker image load  --input ${image}";
    ExecStop = "${pkgs.docker}/bin/docker image rm --force ${name}";
    RemainAfterExit = "yes";
  };
  after = [ "docker.service" ] ;
  requires = [ "docker.service" ] ;
  wantedBy = [ "default.target"];
}
