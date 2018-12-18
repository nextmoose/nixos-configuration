{
  pkgs ? import <nixpkgs> {},
  pass
}:
let
  initialization = (import ../temporary/emacs/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
in
{
  bindMounts = {
    "/srv/host" = {
      hostPath ="/";
      isReadOnly = true;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0.0";
    programs = {
      bash.shellInit = "${initialization}/bin/emacs";
    };
    services = {
      mingetty.autologinUser = "user";
    };
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        pkgs.emacs
	pkgs.git
      ];
    };
  };
  tmpfs = [ "/home" ];
}
