{
  pkgs ? import <nixpkgs> {},
  pass
}:
in
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
    programs.bash.shellInit = "${developer-environment-init}/bin/developer-environment-init";
    services.mingetty.autologinUser = "user";
    sound.enable = true;
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        (import ../utils/custom-script-derivation.nix {
          pkgs = pkgs;
          name = "developer-environment-init";
          src = ../scripts/developer-environment-init;
       })
        pkgs.atom
      ];
    };
  };
  tmpfs = [ "/home" ];
}
