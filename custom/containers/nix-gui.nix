{
  pkgs ? import <nixpkgs> {},
  pass
}:
{
  bindMounts = {
    "/srv/host" = {
      hostPath = "/";
      isReadOnly = true;
    };
    "/srv/home" = {
      hostPath = "/home/user";
      isReadOnly = false;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0.0";
    services.mingetty.autologinUser = "user";
    sound.enable = true;
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        (import ../utils/custom-script-derivation.nix {
          pkgs = pkgs;
          name = "development-environment-init";
          src = ../scripts/development-environment-init;
	  dependencies = [ pass pkgs.coreutils ];
       })
        pkgs.atom
      ];
    };
  };
  tmpfs = [ "/home" ];
}
