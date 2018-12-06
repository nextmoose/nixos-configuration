{
  pkgs ? import <nixpkgs>{},
  pass
}:
{
  config = { config, pkgs, ...}:
  {
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
	      pkgs.pass
      ];
    };
  };
  tmpfs = [ "/home" ];
}
