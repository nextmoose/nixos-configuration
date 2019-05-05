{
  pkgs,
  name,
  entrypoint,
  cmd ? [],
  contents ? []
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