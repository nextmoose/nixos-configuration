{
  pkgs,
  name,
  entrypoint,
  cmd ? [],
  contents ? [],
  uuid,
  docker-container-health-check
}:
pkgs.dockerTools.buildImage {
  name = name;
  contents = contents;
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
    mkdir /home /tmp &&
      useradd --create-home user &&
      chmod 0777 /tmp &&
      true
  '';
  config = {
    entrypoint = entrypoint;
    cmd = cmd;
    HealthCheck = {
      Test = "${docker-container-health-check}/bin/docker-container-health-check";
      Interval = 30000000000;
      Timeout = 10000000000;
      Retries = 3;
    };
    User = "user";
    Volumes = {
      "/home" = {
      };
    };
    Labels = {
      uuid = uuid;
    };
  };
}