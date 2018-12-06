{
  pkgs ? import <nixpkgs>{},
  pass
}:
let
  initialization = (import ../initialization/pass/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
in
{
  config = { config, pkgs, ...}:
  {
    programs.bash = {
      enableCompletion = true;
      interactiveShellInit = ''
        ${initialization}/bin/pass \
          --origin-host github.com \
          --origin-user git \
          --origin-port 22 \
          --origin-organization nextmoose \
          --origin-repository secrets \
          --origin-branch master
      '';
    };
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
