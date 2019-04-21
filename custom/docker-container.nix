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
      ${start-docker-container}/bin/start-docker-container \
        --image ${image} \
	--name ${name} \
	-- ${arguments}
    '';
    ExecStop = "${pkgs.docker}/bin/docker container stop ${name}";
  };
  after = [ "${image}-image.service" ];
  requires = [ "${image}-image.service" ];
  wantedBy = [ "default.target" ];
}