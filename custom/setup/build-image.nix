{
  pkgs,
  name,
  entrypoint,
  cmd ? [],
  contents ? [],
  uuid,
  docker-health-check
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
      Test = [
        "CMD"
        "${docker-health-check}/bin/docker-health-check"
      ];
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