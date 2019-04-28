{
  pkgs,
  name,
  image,
  arguments ? ""
}:
{
  description = "Docker Container Service -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "oneshot";
    ExecStart = ''
      ${pkgs.docker}/bin/docker \
        run \
	--name "${name}" \
	--interactive \
	--tty \
	"${image}" \
	${arguments}
    '';
    ExecStop = "${pkgs.docker}/bin/docker container stop ${name}";
  };
  after = [ "${image}-image.service" ];
  requires = [ "${image}-image.service" ];
  wantedBy = [ "default.target" ];
}