{
  pkgs ? import <nixpkgs> {},
  name,
  image,
  start-docker-container,
  arguments ? ""
}:
{
  description = "Docker Container Service -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "oneshot";
    ExecStart = ''
      ${pkgs.coreutils}/bin/echo ${start-docker-container}/bin/start-docker-container \
        --image ${image} \
	--name ${name} \
	-- ${arguments} &&
	true
    '';
    ExecStop = "${pkgs.docker}/bin/docker container ls";
  };
  after = [ "${image}-image.service" ];
  requires = [ "${image}-image.service" ];
  wantedBy = [ "default.target" ];
}